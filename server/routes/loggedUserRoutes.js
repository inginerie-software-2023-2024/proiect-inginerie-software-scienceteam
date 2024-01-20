const express = require('express');
const multer = require('multer');
const userController = require('../controllers/userController');
const photoProcessingController = require('../controllers/photoProcessingController');
const storage = require('../utils/multerConfig');
const upload = multer({ storage: storage });
const storage2 = multer.memoryStorage();
const upload2 = multer({ storage: storage2 });

const { spawn } = require('child_process');

const sharp = require('sharp');


const router = express.Router();

router.put('/update', userController.updateUser);

router.delete('/delete', userController.deleteUser);   

router.post('/requestResetPassword', userController.requestPasswordReset);

router.post('/resetPassword', userController.resetPassword);

router.post('/uploadPhoto', upload.single('photo'), photoProcessingController.classifyImage);

  
module.exports = router;