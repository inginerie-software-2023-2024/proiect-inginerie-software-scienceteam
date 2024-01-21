const express = require('express');
const dotenv = require('dotenv');   
const connectDB = require("./config/db"); 
const authenticateToken = require('./middleware/authenticate');
const fs = require('fs');
const {insectData, generateInsectPlot, insecticideData, generateInsecticidePlot } = require('../utils/generatePlot');


//DOTENV
dotenv.config();

//MONGODB CONNECTION
connectDB(); 

//REST OBJECT
const app = express();

//MIDDLEWARES
app.use(express.json());


//ROUTES
app.get('', (req, res) => {
    res.status(200).json({
        success: true,
        message: "Welcome to the API"
    });
});

app.use('/api/users', require('./routes/userRoutes'));
app.use('/api/history', authenticateToken, require('./routes/historyRoutes'));
//app.use('/api/dashboard',require('./routes/dashboardRoutes'));
app.use('/api/users/logged', authenticateToken, require('./routes/loggedUserRoutes'));

app.get('/plot', async (req, res) => {
    try {
        const data = await insectData();
        const fileName = 'insectPlot.png';
        await generateInsectPlot(data, fileName);
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
  });

// app.get('/plots', async (req, res) => {
//     try {
//         const plantData = await insectData();
//         const plantFileName = 'plantPlot.png';
//         await generateInsectPlot(plantData, plantFileName); // Schimbați funcția pentru generarea plotului cu datele despre plante

//         const insecticideData = await insecticideData(); // Adăugați o funcție similară pentru datele despre insecticide
//         const insecticideFileName = 'insecticidePlot.png';
//         await generateInsecticidePlot(insecticideData, insecticideFileName); // Adăugați funcția pentru generarea plotului cu datele despre insecticide


//         // Trimiteți ambele imagini către frontend
//         fs.readFile(plantFileName, (err, plantData) => {
//             if (err) {
//                 console.error('Error reading plant image file:', err);
//                 res.status(500).send('Error generating plant plot');
//             } else {
//                 fs.readFile(insecticideFileName, (err, insecticideData) => {
//                     if (err) {
//                         console.error('Error reading insecticide image file:', err);
//                         res.status(500).send('Error generating insecticide plot');
//                     } else {
//                         res.set({
//                             //'Content-Type': 'image/png',
//                             'Content-Type': 'multipart/x-mixed-replace; boundary=frame', // Schimbați tipul conținutului în multipart/form-data
//                             'Content-Length': plantData.length + insecticideData.length // Adăugați și lungimea datelor pentru a trimite ambele imagini
//                         });
//                         res.write(plantData);
//                         res.write(insecticideData); // Trimiteți datele pentru a doua imagine
//                         res.end();
//                     }
//                 });
//             }
//         });
//     } catch (error) {
//         console.error('Error generating plots:', error);
//         res.status(500).send('Error generating plots');
//     }
// });



//PORT
const PORT = process.env.PORT || 8080;

//LISTEN
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});