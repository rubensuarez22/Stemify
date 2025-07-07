# 🚀 STEMify

### **Inclusive Guidance for STEM Careers**

---

## 📖 **Description**
*STEMify* is an inclusive iOS mobile application designed to guide undecided young individuals towards STEM (Science, Technology, Engineering, and Mathematics) careers. It fosters curiosity through guided exploration, gamification, and inspiration from successful role models, making vocational discovery engaging and accessible.

---

## 🚀 **Key Features**
- **Guided Curiosity**: Interactive flows that help users explore STEM fields based on their interests.
- **Gamification**: Engaging elements to make the career exploration process fun and motivating.
- **Role Model Inspiration**: Profiles of STEM professionals to inspire and provide real-world insights.
- **University Geolocalization**: Locate and explore universities offering STEM programs using integrated mapping.
- **Web Scraping Integration**: Access up-to-date information on university programs and career paths.
- **Personalized Flows**: Tailored user journeys based on individual preferences and progress.

---

## 🎯 **Alignment with the United Nations Sustainable Development Goals (SDGs)**
- **SDG 4: Quality Education**
  Supporting inclusive and equitable quality education by providing accessible tools for vocational guidance in STEM fields.
- **SDG 8: Decent Work and Economic Growth**
  Helping young people identify and pursue careers in high-demand STEM sectors, contributing to economic growth and future employment opportunities.

---

## 🛠️ **Technologies Used**
- **Primary Language**: Swift (with SwiftUI)
- **Platform**: iOS
- **APIs/Frameworks**:
  - **CoreLocation**: For precise user location data and university geolocalization.
  - **MapKit**: For integrating interactive maps to visualize university locations.
  - **Firestore (Firebase)**: For scalable backend data storage and real-time updates.
  - **Web Scraping**: Custom implementations for data collection.

---

## 📋 Installation

Follow these steps to set up and run the application:

1.  **Clone the repository**:
    Open a terminal and run the following command:
    ```bash
    git clone [https://github.com/rubensuarez22/Stemify.git](https://github.com/rubensuarez22/Stemify.git)
    cd Stemify
    ```
2.  **Open the project in Xcode**:
    Make sure you have the latest version of Xcode installed on your Mac.
    Double-click the `STEMify.xcodeproj` file (or `STEMify.xcworkspace` if using CocoaPods/Swift Package Manager for dependencies) to open the project in Xcode.

3.  **Set up Firebase (Firestore)**:
    -   Create a new Firebase project in the Firebase Console.
    -   Add an iOS app to your Firebase project and follow the instructions to download `GoogleService-Info.plist`.
    -   Drag `GoogleService-Info.plist` into your Xcode project's root directory.
    -   Ensure Firestore rules are configured correctly for data access.

4.  **Set up Capabilities and Permissions**:
    -   Go to your project settings (select your project in the Xcode Project Navigator, then "Signing & Capabilities").
    -   Ensure the following capabilities are enabled:
        -   **Maps** (for MapKit)
        -   **Background Modes** (if background location updates are used)
    -   Open the `Info.plist` file and add the following privacy permissions for location access:
        ```xml
        <key>NSLocationWhenInUseUsageDescription</key>
        <string>We need your location to show nearby universities and relevant career opportunities.</string>
        <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
        <string>We need your location to provide personalized recommendations even in the background.</string>
        ```

5.  **Run the app**:
    -   Connect an iOS simulator or a real device.
    -   In Xcode, select the target device from the toolbar.
    -   Press the "Run" button (▶) in the top-left corner of Xcode.
    -   The app will compile and launch on your selected device.

6.  **Test the functionality**:
    Use the app to explore career paths, engage with gamified content, and view university locations on the map. Verify that data loads correctly from Firestore.

If you encounter any issues during installation, please open an issue in the repository.

---

## 🌟 Development Team
- Ruben Suárez (@rubensuarez22)
- Emiliano Tofas (@TofasEmix)
- Georgina Zerón (@930r91na)
