const mongoose = require('mongoose');

const connectDB = async () => {
    try{
        await mongoose.connect(process.env.MONGO_URL);
        console.log(`MongoDB connected ${mongoose.connection.host}`);
    }
    catch(err){
        console.log(`error in connection db ${err}`);
    }
}

module.exports = connectDB;