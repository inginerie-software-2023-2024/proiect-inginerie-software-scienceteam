const express = require('express');
const userController = require('../controllers/userController');

const router = express.Router();

router.post('/save', userController.saveUser);
 

router.post('/login', userController.loginUser);

router.post('/requestResetPassword', userController.requestPasswordReset);

router.post('/resetPassword', userController.resetPassword);

module.exports = router;