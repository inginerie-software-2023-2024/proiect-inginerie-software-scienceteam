const mongoose = require('mongoose');
const joi = require('joi'); 


const insectSchema = new mongoose.Schema({
    name:{
        type: String,
        required: true,
        min: 3,
        max: 30
    },
    description:{
        type: String,
        required: true,
        unique: true,
        min: 3,
        max: 30
    },
    plants: {
        type: [String],
        required: true
    },
    insecticide: {
        type: [String],
        required: true
    },
    prevention_methods: {
        type: [String],
        required: true
    }

});



function validateInsect(insect) {
    const schema = joi.object({
        name: joi.string().min(3).max(30).required(),
        description: joi.string().min(3).max(30).required(),
        plants: joi.array().items(joi.string()).min(1).required(),
        insecticide: joi.array().items(joi.string()).min(1).required(),
        prevention_methods: joi.array().items(joi.string()).min(1).required(),
    });

    return schema.validate(insect);
}

const Insect = mongoose.model('Insect', insectSchema);

module.exports = {Insect, validateInsect};