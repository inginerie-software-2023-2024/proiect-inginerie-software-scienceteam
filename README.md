
# BugScan - The app that identifies insects

## Purpose of the project

Our project is a mobile application that can identify bugs from a photo taken or uploaded by the user. The app will also provide information about the bug and how to deal with it, the history of the bugs identified by the user and a dashboard with statistics. 

This project can benefit from future improvements, such as:
- adding more bugs to the database
- adding more information about the bugs
- increasing the accuracy of the machine learning model
- deploying the app 


## Guides on how to use the app locally

### Prerequisites
First of all, you will have to clone the project from this repository. 

You will need to have installed the following:
- Visual Studio Code
- Android Studio Hedgehog | 2023.1.1 Patch 1
- Git lfs
- Node: 18.18.2
- Npm: 9.8.1
- Python : 3.11.5
- Pip: 23.3.1.
- Flutter 3.80.0
- Dart 3.80.0

For the app to work, you will have to do the following steps:
- Open a terminal in the machine_learning directory, and run the following command: 

    `pip install -r requirements.txt`

    `git lfs install`

    `git lfs pull`

- Open a terminal in the server directory, and run the following command: 

    `npm install`

    `npm install -g nodemon`

- Open a terminal in the aplicatie directory, and run the following command:
  
    `flutter pub get`


### Running the app
- In a terminal in server directory, run: 

    `npm start` for starting the server






- To use the emulator you will have to create one in AndroidStudio.
- Depending of the type of processor that you use, you will have to change the setting accordingly.

- You must use VSCode to open the folder aplicatie1/proiect_2 where the app is.

- You will have to select the emulated phone from the bottom right corner instead of the current operating system that VSCode will try to use to run the app.

- Then you can use the run button at the top right corner of the screen.

- If the application has errors from libraries open a command prompt and type `flutter clean` and then `flutter pub get` which reinstalls the required libraries found in the file pubspec.yaml


## Application entry points

### Data sources
We have securely stored our data in MongoDB Atlas, a sophisticated cloud-based database management service designed for MongoDB. This ensures robust and efficient data management for our project.

In the development of this project, we have leveraged the utility of the IP102 dataset, an extensive dataset designed for insect pest recognition. This dataset was introduced in the paper ['IP102: A Large-Scale Benchmark Dataset for Insect Pest Recognition'](https://openaccess.thecvf.com/content_CVPR_2019/papers/Wu_IP102_A_Large-Scale_Benchmark_Dataset_for_Insect_Pest_Recognition_CVPR_2019_paper.pdf). 

Citation for the dataset:

    @inproceedings{Wu2019Insect,
      title={IP102: A Large-Scale Benchmark Dataset for Insect Pest Recognition},
      author={Xiaoping Wu and Chi Zhan and Yukun Lai and Ming-Ming Cheng and Jufeng Yang},
      booktitle={IEEE CVPR},
      pages={8787--8796},
      year={2019},
    }

### Data inputs

For our app, we have the following data inputs:
- for account creation and information update:
  
  ~ User-provided information during the account creation process.
  
  ~ User updates for account information, such as updating personal details.
  
- for insect photo capture or upload:
  
   ~ Images captured using the device's camera feature to photograph insects.
  
   ~ Alternatively, users can upload existing photos from their device's gallery.

- for insect classification:
  
   ~ Captured or uploaded images of insects used as input for the classification algorithm.

- for viewing insect history:

   ~ Retrieval of historical data from the database related to previously classified insects.

   ~ User interactions, such as selecting a specific insect from the history to view detailed information.

- for recovering the forgotten password:

   ~ User's email, provided in the form.

   ~ Upon receiving the reset password email, the code for accesing the reset password functionality, and the new password.


### Configuration files

The configuration files are found in:
- the machine_learning directory, the requirements.txt file.
- the server directory, the package.json file.
- the aplicatie directory, the pubspec.yaml file.

  

## High level diagrams of the architecture 

### User journey

![User_Journey_Map](https://github.com/inginerie-software-2023-2024/proiect-inginerie-software-scienceteam/assets/100355126/0eef20de-aa62-483e-a90e-54d32f91a001)



### Most valuable output

The most valuable output of our application is the classification of an insect from the image provided by the user.


## Deployment plan

As for now, the app is not deployed on any platform. This will be done as a future improvement.


## Description of the QA process

We have run many tests on the app, covering each functional aspect.
On the front-end of the app, unit tests have been run.
These tests check the functionality and workflow of the app on a UI side.
There are also tests checking if the front-end and back-end are integrated properly and work together.
The tests are made in such way as to check the functionality and limits of the app while ensuring that the database will not be affected.

![tests_deschis](https://github.com/inginerie-software-2023-2024/proiect-inginerie-software-scienceteam/assets/93475691/a8d4f71c-b780-4327-8675-88861af964f5)
![tests_inchis](https://github.com/inginerie-software-2023-2024/proiect-inginerie-software-scienceteam/assets/93475691/ada7e23c-4cb2-4145-bc03-4b24d688468f)


On the machine learning side of the app, we developed the test that is found in the machine_learning directory, named [integration_test.py](machine-learning/integration_test.py).
This test check the integration between back-end and machine learning model. It ensures that accuracy remains consistent between the training phase and the integration test during inference.



## External dependencies included in the project

### For Flutter the libraries that were used are:

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


### For Node.js the libraries that were used are:
  
    "dependencies": {
      "bcrypt": "^5.1.1",
      "bindings": "^1.5.0",
      "chartjs-node-canvas": "^4.1.6",
      "cmake-js": "^7.2.1",
      "dotenv": "^16.3.1",
      "express": "^4.18.2",
      "get-pixels": "^3.3.3",
      "handlebars": "^4.7.8",
      "joi": "^17.11.0",
      "jsonwebtoken": "^9.0.2",
      "libtorchjs": "^1.0.0-alpha.4",
      "mongoose": "^8.0.3",
      "multer": "^1.4.5-lts.1",
      "nan": "^2.18.0",
      "nodemailer": "^6.9.8",
      "onnxjs": "^0.1.8",
      "onnxruntime-node": "^1.16.3",
      "pngjs": "^7.0.0",
      "sharp": "^0.33.2",
      "torch-js": "npm:@arition/torch-js@^0.14.0"
    },
    "devDependencies": {
      "nodemon": "^3.0.2"
    }


### For Machine Learning Pipeline the libraries that were used are:

    torch==2.1.0
    torchvision==0.15.2a0
    opencv-python==4.6.0
    albumentations==1.3.1
    Pillow==9.4.0
    numpy==1.26.0
    torcheval==0.0.7
