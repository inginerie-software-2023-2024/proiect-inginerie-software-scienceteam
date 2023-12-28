const express = require('express');
const userController = require('../controllers/userController');

const router = express.Router();

router.post('/save', userController.saveUser);

router.put('/update/:id', userController.updateUser);

router.delete('/delete/:id', userController.deleteUser);    

module.exports = router;