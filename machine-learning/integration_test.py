import requests
import json
import argparse
import numpy as np
from sklearn import metrics
import time


parser = argparse.ArgumentParser(
                    prog='IntegrationTest',
                    description='Integration test for ML and backend')
parser.add_argument('filename',choices=['train','val','test'],default='test',help='choose the dataset to test on')          


def login():
    url = 'http://localhost:8080/api/users/login'
    data = {'username': 'mircea',
            'password': 'mircea'}
    response = requests.post(url, json=data)
    if response.status_code == 200:
        print("Login successfully")
        return json.loads(response.text)['accessToken']
    else:
        print(f"Failed to login. Status code: {response.status_code}, Response text: {response.text}")
        return None
    
    
def inference(file_path,file,token,y_true):
    headers = {'Authorization': f'Bearer {token}'}
    url = 'http://localhost:8080/api/users/logged/uploadPhoto'
    
    with open(file_path, 'rb') as f:
        files = {'photo': (file, f, 'image/jpeg')}
        response = requests.post(url,headers=headers, files=files)
    if response.status_code == 200:
        print("File uploaded successfully")
        print(str(int(response.text[-3:-2])-1),file,y_true,sep=' ')
        return int(response.text[-3:-2])-1
    else:
        print(f"Failed to upload file. Status code: {response.status_code}, Response text: {response.text}")


def refresh_token(start_time,acces_token):
    if time.time() - start_time > 3500:
        print('token expirat')
        acces_token = login()
        start_time = time.time()
        return acces_token,start_time
    else:
        return acces_token,start_time
        
        
if __name__ == '__main__':
    
    args = parser.parse_args()
    file_name = args.filename
    
    start_time = time.time()
    acces_token =login()
    
    images_dir = '/home/mircea/IS/surogat/ip102_v1.1/images/'
    files_to_test = []
    y_true = [] 
    y_pred = []
    
    with open(f'/home/mircea/IS/surogat/ip102_v1.1/{file_name}.txt', 'r') as f:
        lines = f.readlines()
        for line in lines:
            files_to_test.append(line.split()[0])
            y_true.append(int(line.split()[-1]))
            acces_token,start_time = refresh_token(start_time,acces_token)

    for i,file in enumerate(files_to_test):
        time.sleep(1)
        pred = inference(file_path=images_dir + file,file=file,token=acces_token,y_true=y_true[i])
        y_pred.append(pred)
        acces_token,start_time = refresh_token(start_time,acces_token)
        
    y_true = np.array(y_true)
    y_pred = np.array(y_pred)
    
    with open('machine-learning/integration_test.txt','a') as f:
        f.write(f'dataset {file_name}: {metrics.accuracy_score(y_true, y_pred)}')
        f.write('\n')