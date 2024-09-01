# Pitch Pals

Pitch Pals is a football match scheduling and management app designed for enthusiasts who want to easily join, organize, and manage football games. With a sleek and intuitive interface, users can browse available venues, join upcoming games, subscribe to premium memberships, and even get tips on improving their football skills via an integrated chatbot.

## Features

### 1. **User Authentication**
   - Users can sign up, log in, and manage their profiles using Firebase Authentication.
   - The app fetches and displays user data such as the first and last name, which is displayed on the home screen.

### 2. **Venues Management**
   - The app includes a fixed list of football venues (e.g., Maidan, Gharafa Outdoor, and Dome) stored in Firestore.
   - Venues are displayed dynamically on the home screen with filter buttons that allow users to view games associated with a particular venue.
   - Venues are represented by images stored in Firebase Storage and are linked to games scheduled at each venue.

### 3. **Game Scheduling and Management**
   - Users can browse games at different venues, view details such as the date and time, and see how many players have joined.
   - A `Game` model is integrated with Firestore to store game details including the venue, date, time, and list of joined players.
   - Users can join games, and their information is updated in Firestore, ensuring real-time synchronization across all devices.

### 4. **Search Functionality**
   - The search view allows users to search for games by name or location.
   - A clean and simple UI displays games horizontally, with details such as date, location, and the number of joined players.
   - The search bar at the top of the view allows users to input search queries (currently non-functional for filtering, but serves as a UI placeholder).

### 5. **Chatbot Integration**
   - The notification icon has been replaced with a chatbot icon in the custom tab bar.
   - The chatbot feature provides users with tips on improving their football skills and answers general questions about football.

### 6. **Custom Tab Bar**
   - A custom tab bar allows easy navigation between the home screen, search view, chatbot, and user profile.
   - Each tab is represented by an icon (home, search, chatbot, and profile).

### 7. **Stripe Integration for Subscription Plans**
   - Users can subscribe to one of three premium membership plans: Bronze, Silver, and Gold.
   - **Bronze Plan**: Basic access to games with limited features.
   - **Silver Plan**: Enhanced access with more features, including priority booking.
   - **Gold Plan**: Unlimited access to all games and features, with the highest priority booking.
   - Subscription payments are handled securely via Stripe integration.
   - Users can manage their subscription status directly from the app.

## Installation

### Prerequisites
   - Xcode 12 or later
   - Cocoapods
   - Firebase account (Firestore and Firebase Storage set up)
   - Stripe account for handling payments

### Steps to Run the Project
1. Clone the repository.
2. Navigate to the project directory.
3. Install dependencies using CocoaPods:
   ```bash
   pod install
   ```
4. Open the `.xcworkspace` file in Xcode.
5. Set up Firebase by adding your `GoogleService-Info.plist` file to the project.
6. Set up Stripe by configuring your Stripe API keys in the project settings.
7. Ensure all assets (e.g., images for venues) are correctly added to the project's asset catalog.
8. Build and run the app on a simulator or a physical device.

## Usage

### Home Screen
   - The home screen displays a personalized greeting and allows users to browse and filter games by venue.
   - Users can click on a venue filter button to see the games available at that venue.

### Search View
   - The search view allows users to search for games and displays results in a scrollable format.
   - Users can select a game to view more details or join.

### Chatbot
   - Access the chatbot by tapping the message icon on the custom tab bar.
   - Ask questions about football, and get tips on improving your game.

### Profile Management
   - Access your profile by tapping the person icon on the custom tab bar.
   - Manage your personal information, view your joined games, and more.

### Subscriptions
   - Access subscription plans through the profile section.
   - Choose between Bronze, Silver, or Gold plans based on your needs.
   - Manage your subscription and payment details securely via Stripe integration.

## Contributing

Contributions are welcome! Feel free to submit a pull request or open an issue to discuss potential changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments
   - Thanks to Firebase for providing backend services that power user authentication, database, and storage.
   - Thanks to Stripe for enabling secure and reliable payment processing for subscriptions.
   - Special thanks to all contributors who have helped improve this app.

