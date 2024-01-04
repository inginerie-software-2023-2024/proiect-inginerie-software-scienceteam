const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { User, validateUser } = require('../models/userModel');  

const saveUser = async (req, res) => {
    try{
        const validate = await validateUser(req.body);
        if(validate.error){
            throw new Error(validate.error.message);
        }

        const existingUser = await User.findOne({ username: req.body.username });
        if (existingUser) {
            throw new Error("Username already exists");
        }

        validate.password = await bcrypt.hash(req.body.password, 10);

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

        if (userDataToUpdate.password) {
            userDataToUpdate.password = await bcrypt.hash(userDataToUpdate.password, 10);
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

const findUserByUsername = async (username) => {
    try {
      const user = await User.findOne({ username });
      return user;
    } catch (err) {
      throw new Error("Error finding user by username");
    }
  };
  
const loginUser = async (username, password) => {
    try {
        const user = await findUserByUsername(username);

      if (!user || !(await bcrypt.compare(password, user.password))) {
        console.log('Invalid credentials for username:', username);
        throw new Error('Invalid credentials');
      }
  
      const accessToken = jwt.sign({ username: user.username, id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
  
      return { success: true, accessToken };
    } catch (err) {
      throw new Error(err.message || "Error during login");
    }
};

module.exports = {saveUser, updateUser, deleteUser, loginUser};