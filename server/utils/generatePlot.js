const { ChartJSNodeCanvas } = require('chartjs-node-canvas');
const fs = require('fs');

const { Insect } = require('../models/insectModel');

const insectData = async () => {
    try {
      const insectCountByPlant = {};
      const insects = await Insect.find({});
      insects.forEach((insect) => {
        insect.plants.forEach((plant) => {
          if (!insectCountByPlant[plant]) {
            insectCountByPlant[plant] = 0;
          }
          insectCountByPlant[plant] += 1;
        });
      });
  
      // Sort the insectCountByPlant object based on the count values
      const sortedInsectCountByPlant = Object.entries(insectCountByPlant).sort((a, b) => b[1] - a[1]);
  
      // Return only the top 25 entries
      const top10Plants = sortedInsectCountByPlant.slice(0, 25);
  
      return top10Plants.map(([plant, count]) => ({
        plant: plant,
        count: count,
      }));
    } catch (error) {
      console.error('Eroare la extragerea datelor despre insecte: ', error);
      throw error;
    }
  };


const insecticideData = async () => {
    try {
        const insecticideCount = {};
        const insects = await Insect.find({});
        insects.forEach(insect => {
            insect.insecticide.forEach(insecticide => {
                if (!insecticideCount[insecticide]) {
                    insecticideCount[insecticide] = 0;
                }
                insecticideCount[insecticide] += 1;
            });
        });

        const sortedInsecticideCount = Object.entries(insecticideCount).sort((a, b) => b[1] - a[1]);
        const top25Insecticides = sortedInsecticideCount.slice(0, 25);

        return top25Insecticides.map(([insecticide, count]) => ({
            insecticide: insecticide,
            count: count
        }));

    } catch (error) {
        console.error('Eroare la extragerea datelor despre insecticide: ', error);
        throw error;
    }
};


const generateInsectPlot = async (insectData, fileName) => {
    try{
    const chartJSNodeCanvas = new ChartJSNodeCanvas({ width: 600, height: 600 });

    const data = {
        labels: insectData.map(data => data.plant),
        datasets: [{
            label: 'Affected plants (%)',
            data: insectData.map(data => data.count * 100 / 102),
            backgroundColor: 'rgba(0, 123, 255, 0.5)',
            borderColor: 'rgba(0, 123, 255, 1)',
            borderWidth: 1
        }]
    };

    const configuration = {
        type: 'bar',
        data: data,
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    };
    const chartBuffer = await chartJSNodeCanvas.renderToBuffer(configuration);
    
    fs.writeFileSync(fileName, chartBuffer);
    
    return fileName;
    
} catch (error) {
        throw error;
    }
};

const generateInsecticidePlot = async (insecticideData, fileName) => {
    try {
        const chartJSNodeCanvas = new ChartJSNodeCanvas({ width: 600, height: 600 });

        const data = {
            labels: insecticideData.map(data => data.insecticide),
            datasets: [{
                label: 'Insecticides distribution (%)',
                data: insecticideData.map(data => data.count * 100 / 102),
                backgroundColor: 'rgba(255, 99, 132, 0.5)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1
            }]
        };

        const configuration = {
            type: 'bar',
            data: data,
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        };
        const chartBuffer = await chartJSNodeCanvas.renderToBuffer(configuration);

        fs.writeFileSync(fileName, chartBuffer);

        return fileName;
    } catch (error) {
        throw error;
    }
};


module.exports = { insectData, generateInsectPlot, insecticideData, generateInsecticidePlot };