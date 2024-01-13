const mongoose = require('mongoose');


const historySchema = new mongoose.Schema({
    user: { 
        type: mongoose.Schema.Types.ObjectId, 
        required: true,
        ref: 'User' 
    },
    insect: { 
        type: mongoose.Schema.Types.ObjectId, 
        required: true,
        ref: 'Insect' 
    }

});



const History = mongoose.model('History', historySchema);

module.exports = {History};