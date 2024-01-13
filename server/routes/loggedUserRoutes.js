const express = require('express');
const userController = require('../controllers/userController');

const router = express.Router();

router.put('/update/:id', userController.updateUser);

router.delete('/delete/:id', userController.deleteUser);   

router.post('/requestResetPassword', userController.requestPasswordReset);

router.post('/resetPassword', userController.resetPassword);

router.post('/uploadPhoto', upload.single('photo'), async (req, res) => {
    try {
        res.status(200).json({ message: 'Photo uploaded successfully', file: req.file });
    } catch (error) {
        res.status(500).json({ message: 'Error uploading photo', error: error.message });
    }
});

module.exports = router;