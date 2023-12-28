const { User, validateUser } = require('../models/userModel');  

const saveUser = async (req, res) => {
    try{
        const validate = await validateUser(req.body);
        if(validate.error){
            throw new Error(validate.error.message);
        }
        const newUser = new User(req.body);
        await newUser.save();

        res.status(200).json({
            success: true,
            message: "User saved successfully"
        });
    }
    catch(err){
        res.status(400).json({
            success: false,
            message: err.message
        });
    }
};

const updateUser = async (req, res) => {
    const userId = req.params.id;
    const userDataToUpdate = req.body;

    try{

        const validate = await validateUser(userDataToUpdate);
        if(validate.error){
            throw new Error(validate.error.message);
        }

        const user = await User.findByIdAndUpdate(userId, userDataToUpdate);

        if(!user){
            throw new Error("User not found");
        }
        res.status(200).json({
            success: true,
            message: "User updated successfully"
        });

    }
    catch(err){
        res.status(400).json({
            success: false,
            message: err.message
        });
    }
};

const deleteUser = async (req, res) => {
    const userId = req.params.id;
    try {
        const user = await User.findByIdAndDelete(userId);  
        if(!user){
            throw new Error("User not found");
        }
        res.status(200).json({
            success: true,
            message: "User deleted successfully"
        });
    }
    catch(err){
        res.status(400).json({
            success: false,
            message: err.message
        });
    }
};

module.exports = {saveUser, updateUser, deleteUser};