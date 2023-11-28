# Flutter Instagram Clone

A Flutter-based social media app that replicates key features of popular social platforms, including user authentication, post creation, real-time feed updates, and profile management. Firebase is utilized for backend services, handling user authentication, data storage, and image storage.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Authentication](#authentication)
  - [Profile Management](#profile-management)
  - [Feed](#feed)
- [Responsive Design](#responsive-design)
- [Deleting User Account](#deleting-user-account)
- [Folder Structure](#folder-structure)
- [Contributing](#contributing)
- [License](#license)

## Features

- **User Authentication:**
  - Users can register and log in with email authentication.
  - Email verification is required before users can log in.

- **Post Management:**
  - Users can create posts with descriptions.
  - Posts can be deleted by the user.

- **Interactions:**
  - Users can like and comment on posts.
  - Users can follow or unfollow each other.

- **Real-time Feed:**
  - Utilizes StreamBuilder for a real-time feed with posts sorted by the latest first.

- **Profile Management:**
  - Users can edit their profiles, including profile pictures, names, usernames, and bios.

- **Responsive Design:**
  - Provides a responsive layout that adapts to different screen sizes.

- **Secure User Deletion:**
  - Users can delete their accounts, triggering a multi-step process:
    - Reauthentication by entering the password.
    - Deletion of user database and authentication details.
    - Update of other users' profiles who are following or being followed.
    - Deletion of likes and comments from other users' posts.
    - Removal of post details from the database.
    - Deletion of images of posts and profile pictures from storage.

## Getting Started

### Prerequisites

Make sure you have the following installed:

- Flutter: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart: [Install Dart](https://dart.dev/get-dart)

### Installation

Clone the repository and install dependencies.

```bash
git clone https://github.com/your_username/flutter-social-clone.git
cd flutter-social-clone
flutter pub get
flutter run
```

## Usage

### Authentication
- Users register and log in using their email.
- Email verification is required before accessing the app.
- **User Logout:**

  1. Navigate to the profile page.
  2. Find the "Logout" option on top right.
  3. Confirm the action if prompted.
  4. The user is successfully logged out and returned to the login screen.

### Profile Management
- Users can edit their profiles, including profile pictures, names, usernames, and bios.

### Feed
- The feed displays posts in real-time, sorted by the latest first.
- Users can interact with posts by liking and commenting.

## Responsive Design
- The app features a responsive design that adapts to different screen sizes, providing a seamless user experience.

## Deleting User Account
To delete a user account:

  1. Navigate to the Profile Page.
  2. Choose the option to delete the account on top right.
  3. Confirm the action by entering the account password.

The app initiates a secure deletion process, ensuring all associated data is removed.

## Contributing

Feel free to contribute by opening issues or submitting pull requests to enhance the functionality or fix any bugs.

