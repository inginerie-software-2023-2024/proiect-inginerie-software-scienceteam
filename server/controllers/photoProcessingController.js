const fs = require('fs');
const multer = require('multer');
const sharp = require('sharp');
const ort = require('onnxruntime-node');

const storage = require('../utils/multerConfig');
const upload = multer({ storage: storage });

const pixelsArray = async (req, res) => {
    if (!req.file) {
        return res.status(400).send('Nicio imagine încărcată.');
      }
    
      // Utilizează sharp pentru a prelucra imaginea
      sharp(req.file.buffer)
        .raw()
        .toBuffer({ resolveWithObject: true })
        .then(({ data, info }) => {
          const width = info.width;
          const height = info.height;
          const channels = info.channels;
          console.log('Dimensiuni imagine:', width, height);
          // Converteste array-ul de pixeli într-un array de obiecte RGB
          const pixels = [];
          for (let i = 0; i < data.length; i += channels) {
            const pixel = [data[i], data[i + 1], data[i + 2]];
            
            pixels.push(pixel);
          }
    
          // Poți utiliza array-ul de pixeli (pixels) în continuare
          console.log('Array de pixeli:', pixels);
 
         // create a new session and load the specific model.
        //
        // the model in this example contains a single MatMul node
        // it has 2 inputs: 'a'(float32, 3x4) and 'b'(float32, 4x3)
        // it has 1 output: 'c'(float32, 3x3)
        const session =  ort.InferenceSession.create('../machine-learning/resnet152_71acc.onnx');
        // prepare inputs. a tensor need its corresponding TypedArray as data

        const tensor = new ort.Tensor('float32', pixels, [340, 191]);

        // feed inputs and run
        const results =  session.run(tensor);

        // read from results
        const dataC = results.c.data;
        console.log(`data of result tensor 'c': ${dataC}`);
                  
          res.status(200).json( pixels );
        })
        .catch((err) => {
          console.error('Eroare prelucrare imagine:', err);
          res.status(500).send('Eroare prelucrare imagine.');
        });
  };

module.exports = {pixelsArray};