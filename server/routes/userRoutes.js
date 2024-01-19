const express = require('express');
const userController = require('../controllers/userController');

const router = express.Router();

router.post('/save', userController.saveUser);
 

router.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
      const loginResult = await userController.loginUser(username, password);
      res.status(200).json(loginResult);
    } catch (err) {
      res.status(401).json({ success: false, message: err.message });
    }
  });



module.exports = router;