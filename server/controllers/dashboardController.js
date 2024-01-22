const fs = require('fs');
const {insectData, generateInsectPlot, insecticideData, generateInsecticidePlot } = require('../utils/generatePlot');


const getPlot = async (req, res) => {
            try {
                const data = await insecticideData();
                const fileName = './plots/insectPlot.png';
                await generateInsecticidePlot(data, fileName);
                // Send the image file as a response
                fs.readFile(fileName, (err, data) => {
                    if (err) {
                        console.error('Error reading image file:', err);
                        res.status(500).send('Error generating plot');
                    } else {
                        res.set({
                            'Content-Type': 'image/png',
                            'Content-Length': data.length
                        });
                        res.send(data);
                    }
                });
            } catch (error) {
                console.error('Error generating plot:', error);
                res.status(500).send('Error generating plot');
            }
        };
const getPlot2 = async (req, res) => {
            try {
                const data = await insectData();
                const fileName = './plots/plantPlot.png';
                await generateInsectPlot(data, fileName);
                fs.readFile(fileName, (err, data) => {
                    if (err) {
                        console.error('Error reading image file:', err);
                        res.status(500).send('Error generating plot');
                    } else {
                        res.set({
                            'Content-Type': 'image/png',
                            'Content-Length': data.length
                        });
                        res.send(data);
                    }
                });
            } catch (error) {
                console.error('Error generating plot:', error);
                res.status(500).send('Error generating plot');
            }
        };        


module.exports = {getPlot, getPlot2};        