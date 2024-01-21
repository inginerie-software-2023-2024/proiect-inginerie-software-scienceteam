const express = require('express');
const dashboardController = require('../controllers/dashboardController');

const router = express.Router();
router.get('/getPlot', dashboardController.getPlot);

module.exports = router;