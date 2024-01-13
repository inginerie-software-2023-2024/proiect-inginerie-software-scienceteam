const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { User, validateUser } = require('../models/userModel');  
const { Token } = require('../models/tokenModel');
const sendEmail = require('../utils/email/sendEmail');
const crypto = require("crypto");

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
        
        req.body.password = await bcrypt.hash(req.body.password, 10);

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
    const userId = req.user.id;
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
    const userId = req.user.id;
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
        //const passwordMatch = await bcrypt.compare(password, user.password);
      if (!user || !(await bcrypt.compare(password, user.password))) {
        //console.log('Password:', passwordMatch);
        //console.log('Stored password:', user.password);
        //console.log('Entered password:', password);
        //console.log('Invalid credentials for username:', username);
        throw new Error('Invalid credentials');
      }
  
      const accessToken = jwt.sign({ username: user.username, id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
  
      return { success: true, accessToken };
    } catch (err) {
      throw new Error(err.message || "Error during login");
    }
};

const requestPasswordReset = async (req, res) => {
    try{
        const email = req.body.email;

        const user = await User.findOne({ email });

        if (!user) throw new Error("User does not exist");

        let token = await Token.findOne({ userId: user._id });

        if (token) await token.deleteOne();

        let resetToken = crypto.randomBytes(32).toString("hex");
        const hash = await bcrypt.hash(resetToken, Number(process.env.BCRYPT_SALT));

        await new Token({
            userId: user._id,
            token: hash,
            createdAt: Date.now(),
        }).save();

        const link = `${ process.env.CLIENT_URL }/passwordReset?token=${resetToken}&id=${user._id}`;
        sendEmail(user.email,"Password Reset Request",{name: user.name,link: link,},"./template/requestResetPassword.handlebars");
        res.status(200).json({
            success: true,
            message: "Reset password link sent successfully, please check your email",
            link : link
        });
    }
    catch(err){
        res.status(400).json({
            success: false,
            message: err.message
        });
    }
    
};

const resetPassword = async (req, res) => {

    try{
        const {userId, token, password} = req.body;

        let passwordResetToken = await Token.findOne({ userId });

        if (!passwordResetToken) {
        throw new Error("Invalid or expired password reset token");
        }
        const isValid = await bcrypt.compare(token, passwordResetToken.token);
        if (!isValid) {
        throw new Error("Invalid or expired password reset token");
        }

        const hash = await bcrypt.hash(password, Number(process.env.BCRYPT_SALT));

        await User.updateOne(
        { _id: userId },
        { $set: { password: hash } },
        { new: true }
        );

        const user = await User.findById({ _id: userId });

        sendEmail(
        user.email,
        "Password Reset Successfully",
        {
            name: user.name,
        },
        "./template/resetPassword.handlebars"
        );

        await passwordResetToken.deleteOne();

        res.status(200).json({
            success: true,
            message: "Password reset successfully"
        });
    }
    catch(err){
        res.status(400).json({
            success: false,
            message: err.message
        });
    }
    
};

module.exports = {saveUser, updateUser, deleteUser, loginUser, requestPasswordReset, resetPassword};