import FirebaseDatabase
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    // MARK: - Variables
    var isLoading = false
    var errorMessage: String?
    var isSignUpSuccessful = false
    
    // Add the @Published property wrappers here
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Firestore
        let db = Firestore.firestore()

        // ... (Your other view setup)

        // Configure UI elements
        signUpButton.isEnabled = false
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        // Add observers for text field changes
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    // MARK: - Actions
    @objc func signUpButtonTapped() {
        signUp()
    }

    @objc func textFieldDidChange() {
        // Enable the sign up button if all fields are filled
        signUpButton.isEnabled = !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty && !usernameTextField.text!.isEmpty && !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty
    }

    // MARK: - Sign Up Logic
    func signUp() {
        isLoading = true
        errorMessage = nil

        // Get values from text fields
        if let email = emailTextField.text, !email.isEmpty,
           let password = passwordTextField.text, !password.isEmpty,
           let username = usernameTextField.text, !username.isEmpty,
           let firstName = firstNameTextField.text, !firstName.isEmpty,
           let lastName = lastNameTextField.text, !lastName.isEmpty {
            // All fields are filled, proceed with your logic
            // ...
        } else {
            // Handle the case where one or more fields are empty
            self.errorMessage = "Please fill in all fields."
            self.isLoading = false
            return
        }



        // Firebase Auth sign up
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = "Failed to sign up: \(error.localizedDescription)"
                self.isLoading = false
                return
            }

            guard let userId = authResult?.user.uid else {
                self.errorMessage = "Failed to retrieve user ID."
                self.isLoading = false
                return
            }

            // Save user details in Firestore
            self.saveUserDetails(userId: userId, email: self.email, password: self.password, username: self.username, firstName: self.firstName, lastName: self.lastName)
        }
    }

    // MARK: - Save User Details
    private func saveUserDetails(userId: String, email: String, password: String, username: String, firstName: String, lastName: String) {
        let userData: [String: Any] = [
            "email": email,
            "password": password, // You might want to store a hashed password for security
            "username": username,
            "firstName": firstName,
            "lastName": lastName
        ]

        // Use Firestore to save user data
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        let userDocument = usersCollection.document(userId)

        userDocument.setData(userData) { error in
            if let error = error {
                self.errorMessage = "Failed to save user details: \(error.localizedDescription)"
            } else {
                self.isSignUpSuccessful = true
                self.isLoading = false
                // You can navigate to another view or update the UI accordingly
            }
        }
    }
}
