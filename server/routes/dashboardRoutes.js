const express = require('express');
const dashboardController = require('../controllers/dashboardController');

const router = express.Router();
router.get('/getPlot', dashboardController.getPlot);
router.get('/getPlot2', dashboardController.getPlot2);

module.exports = router;