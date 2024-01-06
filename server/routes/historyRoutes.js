const express = require('express');
const historyController = require('../controllers/historyController');

const router = express.Router();

router.get('/get/:id', historyController.getHistory);

module.exports = router;