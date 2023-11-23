# Bread Container
The Bread Container is an Android application designed to efficiently manage wooden bread containers and save the remaining bread.

This README file provides a comprehensive guide to the project, including its purpose, features, hardware setup, software installation, and usage instructions.

## Overview
The Bread Container is a comprehensive solution for tracking and managing wooden bread containers using an Android application. The app aims to minimize bread waste by providing real-time container status, location, and sensor data to users. The project utilizes Arduino boards, such as Arduino Nano and NodeMCUESP 8266, along with LED lighting and ultrasonic sensors, to collect container data. The data is then processed and sent to the Android application through Firebase, a cloud-based database.

## Features
### User Features
Container Display: View the list of containers, their locations, and their status.
Location Navigation: Access container locations and navigate to them using maps or location-based services.
Sensor Data Display: Monitor container status through sensor data linked to the containers.
### Admin Features
Container Management: Add, update, and delete container information.
Contact Us Page: Modify data on the Contact Us page.
## Hardware Setup
To set up the hardware components for the Bread Container, follow these steps:

- Arduino Boards: Connect the Arduino Nano and MCU ESP 8266 Node boards appropriately. Ensure they are properly soldered and connected according to the project requirements.

- LED Lighting: Connect LED lights to the Arduino boards as per the project design. Follow the wiring instructions and make sure the connections are secure.

- Ultrasonic Sensors: Connect the ultrasonic sensors to the Arduino boards. Ensure the sensors are connected to the appropriate pins and check for any additional wiring requirements specific to the sensors used.

## Software Installation
To install and configure the software components for the Bread Container, follow these steps:

- Arduino IDE: Download and install the [Arduino IDE](https://www.arduino.cc/en/software) (Integrated Development Environment) from the official Arduino website. This IDE allows you to program the Arduino boards.

- Programming the Arduino: Open the Arduino IDE and load the provided hardware codes written in C++. Connect the Arduino board to your computer using a USB cable and select the correct board and port in the - Arduino IDE. Upload the code to the respective Arduino boards.

- Firebase Setup: Create a [Firebase account](https://firebase.google.com/products-build) if you don't have one already. Set up a new project within Firebase and follow the documentation to create a Realtime Database. Configure the database rules and permissions to ensure secure access.

- Android Studio and Flutter: [Install Android Studio](https://developer.android.com/studio), the integrated development environment for Android app development. Follow the official Flutter documentation to install [Flutter SDK](https://docs.flutter.dev/get-started/install) and set it up with Android Studio.

- Flutter Programming: Open the project in Android Studio and locate the software codes written in Dart. Use the Dart language within the Flutter framework to program the Android application.

- Firebase Integration: Configure the Android app to connect with Firebase. Update the project's configuration files, such as google-services.json, with your Firebase project credentials. This includes the API key, database URL, and authentication settings.

## Usage
Once the Bread Container Android app is installed and running on your device, follow these instructions to use the app effectively:

User Login: Use the app login interface to authenticate yourself as a user.

User Interface Navigation: Explore the app's user interface to access different features and functionalities. Familiarize yourself with the layout and menu options to easily navigate through the app's various sections.

View Container Data: Access the list of containers to view their details, including location and sensor-based status information.

Navigate to Container: Utilize the app's navigation feature to find the location of a specific container. Use maps or location-based services to guide you to the container's position.

Admin Login: Authenticate yourself as an admin to access additional features.

Admin Privileges: As an admin, you can manage containers by adding, updating, and deleting container information. Additionally, you can modify data on the Contact Us page as needed.

Note: To access admin privileges within the application, log in using the designated email and password specific to the admin account. Once logged in, all the pages and permissions available to the admin will be accessible.

## Contributing
Contributions to the Bread Container Android app project are welcome! 
If you have any ideas, suggestions, or bug reports, please contact us by email.

Special Thanks to Our supervisor Dr.Hanan Alasmri
- Ammar Alqahtani
- Anas Alyabis

## Contact
For any further inquiries or questions regarding the Bread Container app, please feel free to contact the project team at BreadContainer.1@gmail.com. We appreciate your interest in the project and look forward to your involvement in improving it!
