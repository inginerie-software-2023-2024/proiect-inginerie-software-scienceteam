const express = require('express');
const dotenv = require('dotenv');   
const connectDB = require("./config/db"); 
const authenticateToken = require('./middleware/authenticate');

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

//PORT
const PORT = process.env.PORT || 8080;

//LISTEN
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});