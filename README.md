2. Instructions on running the Flutter app and android emulator.

The programs required for these tasks are: VSCode and AndroidStudio

VSCode will be used for developing and running the application.
AndroidStudio will be used for emulating the phone.

VSCode will run the application and so it will require the apropriate extensions: Dart and Flutter.
These two extensions will make running the dart code possible.

Also you will need the FlutterMaster installed in your computer.

To use the emulator you will have to create one in AndroidStudio.
Depending of the type of processor that you use, you will have to change the setting accordingly.

The flutter app can be created from the VSCode commands, but as the project is already finished, only running it will be required.
You must use VSCode to open the folder PROIECT_2 where the app is.
You will have to select the emulated phone from the bottom right corner instead of the current operating system that VSCode will try to use to run the app.
Then you can use the run button at the top right corner of the screen.

If the application has errors from libraries open a command prompt and type "flutter pub get" which installs the required libraries found in the file pubspec.yaml

Here are links for the required resources and additional instructions:
- Flutter download + tutorial for setup https://docs.flutter.dev/get-started/install
- VSCode install https://code.visualstudio.com/
- AndroidStudio https://developer.android.com/studio
- Set up the emulator + SDK https://www.youtube.com/watch?v=ly0hAtV7EBg
- Add photos to the emulator https://www.youtube.com/shorts/QL9i27xKqdc
- Git https://git-scm.com/

4. Most valuable output.

The most valuable output of our application is the detection and classification of an insect from the image provided by the user.

5. Deployment:

The app can be deployed, but as this would require expensive investments in both AI - training and database management we chose to present the beta version of the app.

6. Test descriptions.

We have run many tests on the app, covering each functional aspect.
On the front-end of the app, unit tests have been run.
These tests check the functionality and workflow of the app on a UI side.
There are also tests checking if the front-end and back-end are integrated properly and work together.
The tests are made in such way as to check the functionality and limits of the app while ensuring that the database will not be affected.

![tests_deschis](https://github.com/inginerie-software-2023-2024/proiect-inginerie-software-scienceteam/assets/93475691/a8d4f71c-b780-4327-8675-88861af964f5)
![tests_inchis](https://github.com/inginerie-software-2023-2024/proiect-inginerie-software-scienceteam/assets/93475691/ada7e23c-4cb2-4145-bc03-4b24d688468f)



7. Libraries used

For Flutter the libraries that were used are:
  flutter:
    
    sdk: flutter
    
    image_picker: ^1.0.7
    
    realm: 1.6.1
    
    shared_preferences: ^2.0.12
    
    mongo_dart: 0.10.0
    
    http: ^1.2.0
    
    url_launcher: ^6.0.10
    
    uni_links: ^0.5.0
    
    go_router: ^12.1.1
    
    cupertino_icons: ^1.0.2
    
    web_socket_channel: ^2.4.0
    
    mockito: ^5.4.4

and
  flutter_test:
    
    sdk: flutter




