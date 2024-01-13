const express = require('express');
const multer = require('multer');
const userController = require('../controllers/userController');
const photoProcessingController = require('../controllers/photoProcessingController');
const storage = require('../utils/multerConfig');
const upload = multer({ storage: storage });
const storage2 = multer.memoryStorage();
const upload2 = multer({ storage: storage2 });

const sharp = require('sharp');


const router = express.Router();

router.put('/update', userController.updateUser);

router.delete('/delete', userController.deleteUser);   

router.post('/requestResetPassword', userController.requestPasswordReset);

router.post('/resetPassword', userController.resetPassword);

router.post('/uploadPhoto', upload.single('photo'), async (req, res) => {
    try {
        res.status(200).json({ message: 'Photo uploaded successfully', file: req.file });
    } catch (error) {
        res.status(500).json({ message: 'Error uploading photo', error: error.message });
    }
});

router.post('/uploadPhoto2', upload2.single('photo'),photoProcessingController.pixelsArray); 
  
module.exports = router;