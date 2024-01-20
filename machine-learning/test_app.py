import requests
import json


url = 'http://localhost:8080/api/users/logged/uploadPhoto2'

images_dir = '/home/simona/mircea/surogat/ip102_v1.1/images/'
# Replace 'your_photo.jpg' with the actual path to your .jpeg file

files_to_test = []
with open('/home/simona/mircea/surogat/ip102_v1.1/train.txt', 'r') as f:
    lines = f.readlines()
    for line in lines:
        if line.split()[-1] == '0':
            files_to_test.append(line.split()[0])

for file in files_to_test:
    file_path = images_dir + file
    # Open the file in binary mode
    with open(file_path, 'rb') as f:
        files = {'photo': (file, f, 'image/jpeg')}
        response = requests.post(url, files=files)

    # Check the response
    if response.status_code == 200:
        print("File uploaded successfully")
        print(response.text,file,sep=' ')
        
    else:
        print(f"Failed to upload file. Status code: {response.status_code}, Response text: {response.text}")