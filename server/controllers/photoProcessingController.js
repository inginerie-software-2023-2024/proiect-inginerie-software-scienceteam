const {Insect} = require('../models/insectModel');
const { spawn } = require('child_process');
const fs = require('fs');


const classifyImage = async (req, res) => {
  const pythonScriptPath = '/home/simona/Desktop/Proiect IS/proiect-inginerie-software-scienceteam/machine-learning/inference.py';

    const pythonArgs = ['../server/uploads/' + req.file.filename];
    
    // Spawn a new Python process
    const pythonProcess = spawn('python', [pythonScriptPath, ...pythonArgs]);

    // Capture the output of the Python script
    pythonProcess.stdout.on('data', async (data) => {
        console.log(`Python Output: ${data}`);
        try{
          const insect = await Insect.findOne({number: parseInt(data)+1});

          fs.unlinkSync('../server/uploads/' + req.file.filename);
          res.status(200).json({
              success: true,
              data: insect
          });
        }
        catch(err){
            res.status(400).json({
                success: false,
                message: err.message
            });
        }
    });

    // Handle errors
    pythonProcess.stderr.on('data', (data) => {
        console.error(`Error from Python: ${data}`);
    });

    // Handle the process termination
    pythonProcess.on('close', (code) => {
        console.log(`Python process exited with code ${code}`);
    });
};

module.exports = {classifyImage};