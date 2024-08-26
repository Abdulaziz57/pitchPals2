import FirebaseDatabase
import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController {
    var email: String = ""
    var password: String = ""
    var username: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var isLoading = false
    var errorMessage: String?
    var isSignUpSuccessful = false

    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }

    func signUp() {
        isLoading = true
        errorMessage = nil

        // Validate inputs
        guard !email.isEmpty, !password.isEmpty, !username.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
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

            // Save user details in Firebase Database
            self.saveUserDetails(userId: userId)
        }
    }

    private func saveUserDetails(userId: String) {
        let userData: [String: Any] = [
            "username": username,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "profileImageUrl": "Profile-Image-URL", // Replace this with actual profile image URL if available
            "statistics": [
                "gamesPlayed": 0,
                "gamesWon": 0,
                "gamesLost": 0,
                "totalGoals": 0
            ],
            "following": [],
            "followers": [],
            "pastGames": [],
            "upcomingGames": []
        ]

        ref.child("users").child(userId).setValue(userData) { [weak self] error, _ in
            guard let self = self else { return }
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
