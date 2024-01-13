const mongoose = require('mongoose');
const joi = require('joi'); 


const userSchema = new mongoose.Schema({
    username:{
        type: String,
        required: true,
        min: 3,
        max: 30
    },
    email:{
        type: String,
        required: true,
        unique: true,
        min: 3,
        max: 30
    },
    password:{
        type: String,
        required: true,
        min: 3,
        max: 255
    },
    repeat_password:{
        type: String,
        required: true,
        min: 3,
        max: 255
    }
});


function validateUser(user) {
    const schema = joi.object({
        username: joi.string().alphanum().min(3).max(30).required(),
        email: joi.string().email().required(),
        password: joi.string().pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')).required(),
        repeat_password: joi.ref('password')
    
    })

    return schema.validate(user);
}


const User = mongoose.model('User', userSchema);

module.exports = {User, validateUser};