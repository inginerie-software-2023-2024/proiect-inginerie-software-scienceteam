const {History} = require('../models/historyModel');


const getHistory = async (req, res) => {

    try{
        const history = await History.find({user: req.params.id}).populate('insect');
        res.status(200).json({
            success: true,
            data: history
        });
    }
    catch(err){
        res.status(400).json({
            success: false,
            message: err.message
        });
    }
};

module.exports = {getHistory};