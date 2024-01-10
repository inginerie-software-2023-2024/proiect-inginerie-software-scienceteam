const {History} = require('../models/historyModel');
const {Insect} = require('../models/insectModel');

const getHistory = async (req, res) => {

    try{
        if (!req.user || !req.user.id) {
            return res.status(403).json({ message: 'Acces interzis - Utilizatorul nu este autentificat' });
          }
      
        console.log(req.user);
        const userId = req.user.id;
        const history = await History.find({ user: userId }).populate('insect');
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

const addHistory = async (req, res) => {
    
        try{
            if (!req.user || !req.user.id) {
                return res.status(403).json({ message: 'Acces interzis - Utilizatorul nu este autentificat' });
            }
          
            const userId = req.user.id;
            req.body.user = userId;

            const history = await History.create(req.body);
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

module.exports = {getHistory, addHistory};