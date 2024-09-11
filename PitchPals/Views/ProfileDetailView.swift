//
//  ProfileDetailView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI
import Firebase
import FirebaseStorage
import UIKit
import PhotosUI


struct ProfileDetailView: View {
    @State private var user: User? = nil
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    @State private var isCropperPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Header with chevron and title
            ZStack {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)

                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding()
                            .background(Circle().fill(Color(.systemGray6)))
                    }
                    .padding(.leading, 15)

                    Spacer()
                }
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)

            VStack {
                ZStack {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                    } else if let profileImageUrl = URL(string: user?.profileImageUrl ?? "") {
                        AsyncImage(url: profileImageUrl) { image in
                            image
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }

                    // Camera button for image selection
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: 35, y: 35)
                    }
                }
                .padding()

                if let user = user {
                    VStack {
                        VStack(alignment: .leading, spacing: 15) {
                            Group {
                                // First Name Field
                                Text("First Name")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                TextField("First Name", text: Binding(
                                    get: { user.firstName },
                                    set: { self.user?.firstName = $0 }
                                ))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5))
                                )

                                // Last Name Field
                                Text("Last Name")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                TextField("Last Name", text: Binding(
                                    get: { user.lastName },
                                    set: { self.user?.lastName = $0 }
                                ))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5))
                                )

                                // Username Field
                                Text("Username")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                TextField("Username", text: Binding(
                                    get: { user.username },
                                    set: { self.user?.username = $0 }
                                ))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5))
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 100)

                        Button(action: {
                            saveProfileDetails()
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)
                    }
                } else {
                    ProgressView("Loading user data...")
                }

                Spacer()
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: fetchUserProfile)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $profileImage, isPresented: $isImagePickerPresented)
                .onChange(of: profileImage) { newImage in
                    if newImage != nil {
                        isCropperPresented = true // Open the cropper after image selection
                    }
                }
        }

        .sheet(isPresented: $isCropperPresented) {
            if let image = profileImage {
                ImageCropperView(image: $profileImage) { croppedImage in
                    profileImage = croppedImage // Set the cropped image
                }
            }
        }

        .navigationBarBackButtonHidden(true)
    }

    // Function to fetch user data from Firestore
    func fetchUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("Users").document(userId)

        userDocRef.getDocument { document, error in
            if let document = document, document.exists {
                if let userData = document.data() {
                    if let user = User(id: userId, dictionary: userData) {
                        self.user = user // Update the user state with the fetched data
                    }
                }
            } else {
                print("User document does not exist: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func saveProfileDetails() {
        guard let userId = Auth.auth().currentUser?.uid, var user = user else {
            print("User is not logged in")
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("Users").document(userId)

        var updatedData: [String: Any] = [
            "firstName": user.firstName,
            "lastName": user.lastName,
            "username": user.username,
            "profileImageUrl": user.profileImageUrl
        ]

        if let profileImage = profileImage {
            uploadProfileImage(profileImage) { url in
                if let downloadURL = url {
                    updatedData["profileImageUrl"] = downloadURL.absoluteString
                    user.profileImageUrl = downloadURL.absoluteString

                    userDocRef.updateData(updatedData) { error in
                        if let error = error {
                            print("Error updating profile: \(error.localizedDescription)")
                        } else {
                            print("Profile successfully updated")
                        }
                    }
                }
            }
        } else {
            userDocRef.updateData(updatedData) { error in
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                } else {
                    print("Profile successfully updated")
                }
            }
        }
    }

    func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)

        guard let data = imageData else {
            completion(nil)
            return
        }

        let imageRef = storageRef.child("profileImages/\(UUID().uuidString).jpg")

        imageRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error retrieving download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                completion(url)
            }
        }
    }
}


    
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false // Dismiss the picker

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // Only images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}



#Preview {
    ProfileDetailView()
}
