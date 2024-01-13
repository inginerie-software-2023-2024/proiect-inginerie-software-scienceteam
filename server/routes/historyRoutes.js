const express = require('express');
const historyController = require('../controllers/historyController');

const router = express.Router();
router.get('/getHistory', historyController.getHistory);
router.post('/addHistory', historyController.addHistory);

module.exports = router;