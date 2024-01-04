from collections import Counter
import cv2
import numpy as np
import albumentations as A
import shutil
import os
import sys
from PIL import Image
from tqdm import tqdm
import os



def rewrite_files(destination_dir, partition):
    f = open('temporal_adnotations/temporal_train.txt','r')
    g = open(f'/home/mircea/IS/{destination_dir}/ip102_v1.1/{partition}.txt','a')
    for line in f.readlines():
        g.write(line)
    f.close()
    g.close()


def copy_images(destination_file):
    source_directory = 'temporal_images/'
    destination_directory = f'/home/mircea/IS/{destination_file}/ip102_v1.1/images/'

    # Get the list of image files in the source directory
    image_files = [file for file in os.listdir(source_directory) if file.endswith('.jpg')]

    # Copy each image file to the destination directory
    for file in image_files:
        source_path = os.path.join(source_directory, file)
        destination_path = os.path.join(destination_directory, file)
        shutil.copyfile(source_path, destination_path)

    print("Images copied successfully.")


def augment_image(img,it):
    transform1 = A.Compose([
        A.VerticalFlip(p=1,always_apply=True),
        
    ])
    transform2 = A.Compose([
        A.HorizontalFlip(p=1,always_apply=True),
        
    ])
    transform3 = A.Compose([
        A.VerticalFlip(p=1,always_apply=True),
        A.HorizontalFlip(p=1,always_apply=True),
        
    ])
    transform4 = A.Compose([
        A.HueSaturationValue(p=1,always_apply=True),  
    ])
    transform5 = A.Compose([
        A.RandomBrightnessContrast(p=1,always_apply=True),
        A.VerticalFlip(p=1,always_apply=True)
    ])
    transform6 = A.Compose([
        A.InvertImg(p=1,always_apply=True)  
    ])
    transform7 = A.Compose([
        A.PixelDropout(p=1,always_apply=True),
        A.HorizontalFlip(p=1,always_apply=True)
    ])
    transform8 = A.Compose([
        A.AdvancedBlur(p=1,always_apply=True),
        A.RGBShift(p=1,always_apply=True)
    ])
    transform9 = A.Compose([
        A.Downscale(p=1,always_apply=True,scale_min=0.4,scale_max=0.6)
    ])
    transform11 = A.Compose([
        A.Sharpen(p=1,always_apply=True),
        A.VerticalFlip(p=1,always_apply=True)
    ])
    transform10 = A.Compose([
        A.ChannelShuffle(p=1,always_apply=True),
        A.HorizontalFlip(p=1,always_apply=True)
    ])
    transform13 = A.Compose([
        A.Solarize(p=1,always_apply=True,threshold=220),
        A.HorizontalFlip(p=1,always_apply=True)
    ])
    transform12 = A.Compose([
        A.ZoomBlur(p=1,always_apply=True),
    ])
    transform19 = A.Compose([
        A.CropAndPad(p=1,always_apply=True,px=20),
        A.MedianBlur(p=1,always_apply=True)
    ])
    transform17 = A.Compose([
        A.Equalize(p=1,always_apply=True),
        A.VerticalFlip(p=1,always_apply=True)
    ])
    transform16 = A.Compose([
        A.GaussNoise(p=1,always_apply=True),
        A.HorizontalFlip(p=1,always_apply=True),
        A.VerticalFlip(p=1,always_apply=True)
    ])
    transform23 = A.Compose([
        A.Defocus(p=1,always_apply=True),
    ])
    transform15 = A.Compose([
        A.GlassBlur(p=1,always_apply=True,sigma=0.1,iterations=1),
    ])
    transform18 = A.Compose([
        A.MotionBlur (p=1,always_apply=True),
        A.HorizontalFlip(p=1,always_apply=True),
        A.VerticalFlip(p=0.5,always_apply=True)
    ])
    transform14 = A.Compose([
        A.RandomResizedCrop(p=1,always_apply=True,scale=(0.5, 1.0),height=224,width=224),
    ])
    transform20 = A.Compose([
        A.RandomSizedCrop(p=1,always_apply=True,min_max_height=(100, 200),height=224,width=224),
        A.HorizontalFlip(p=1,always_apply=True)
    ])
    transform21 = A.Compose([
        A.FancyPCA(p=1,always_apply=True,alpha=1),
        A.RandomBrightnessContrast(p=1,always_apply=True),
        A.HorizontalFlip(p=1,always_apply=True),
    ])
    transform22 = A.Compose([
        A.ImageCompression(p=1,always_apply=True,quality_lower=6,quality_upper=6),
        A.HorizontalFlip(p=1,always_apply=True)
    ])
    transforms = [transform1,transform2,transform3,transform4,transform5,transform6,transform7,transform8,transform9,transform10,transform11,transform12,transform13,transform14,transform15,transform16,transform17,transform18,transform19,transform20,transform21,transform22,transform23]
    transform = transforms[it] 
    img = transform(image=img)['image']
    return img



def create_temporal_directory():

    directory_path = 'temporal_images'

    if not os.path.exists(directory_path):
        os.makedirs(directory_path)
        
        
def delete_temporal_directory():
    directory_path = 'temporal_images'
    if os.path.exists(directory_path):
        shutil.rmtree(directory_path)

def get_files_names(directory,partition):
    files_names = []
    with open(f'/home/mircea/IS/{directory}/ip102_v1.1/{partition}.txt','r') as f:
        files_names = f.readlines()
        
    files_names = [x[:-1] for x in files_names]
    files_names.sort()
    
    return files_names

def get_files_labels(files_names,partition):
    files = [x.split(' ')[0] for x in files_names]
    labels = [int(x.split(' ')[1]) for x in files_names]
    return files, labels

def main():
    args = sys.argv
    no_needed_images = int(args[1])
    partition = args[2]
    destination_directory = args[3]
    
    create_temporal_directory()
    files_names = get_files_names(destination_directory,partition)
    _,labels = get_files_labels(files_names,partition)
    c = Counter(labels)
    starting_index = 200000
    l = [(no_needed_images-x[1]) for x in c.most_common() if x[1] < no_needed_images]
    print('Will be added', sum(l), 'images')
    
    minority_classes = [x[0] for x in c.most_common() if x[1]< no_needed_images]
    print('Minority classes', minority_classes)
    
    
    examples_per_minority_class = {c:0 for c in minority_classes}
    for train_file_name in tqdm(files_names):
        if int(train_file_name.split(' ')[1]) in minority_classes:
            examples_per_minority_class[int(train_file_name.split(' ')[1])] += 1
    
    images_per_minority_class = {c:[] for c in minority_classes}
    for train_file_name in tqdm(files_names):
        if int(train_file_name.split(' ')[1]) in minority_classes:
            images_per_minority_class[int(train_file_name.split(' ')[1])].append(train_file_name.split(' ')[0])
    


    base_directory_path = f'/home/mircea/IS/{destination_directory}/ip102_v1.1/images/'
    train_txt_directory_path = f'/home/mircea/IS/{destination_directory}/ip102_v1.1/{partition}.txt'
    temporal_images_directory = 'temporal_images/'
    temporal_adnotations_directory = 'temporal_adnotations/'
    
    f = open('temporal_adnotations/temporal_train.txt','w')

    for cls in tqdm(images_per_minority_class.keys()):
       
        no_augmented_images_for_class = 0
        it = 0
        while examples_per_minority_class[cls] < no_needed_images:
            
            for img_file in images_per_minority_class[cls]:
                
                img = Image.open(base_directory_path+img_file)
                img = img.resize((224,224))
                img = img.convert('RGB')
                img = np.array(img)
                augmented_image = augment_image(img,it)
            
                augmented_image = Image.fromarray(augmented_image)
                augmented_image = augmented_image.convert('RGB')
              
              
                augmented_image.save(temporal_images_directory+str(starting_index)+'.jpg')
                    
                f.write(str(starting_index)+'.jpg'+' '+str(cls)+'\n')
                
                starting_index += 1
                examples_per_minority_class[cls] += 1
                no_augmented_images_for_class += 1
                if examples_per_minority_class[cls] >= no_needed_images:
                    break
            it += 1
        print(f'Class {cls} has {no_augmented_images_for_class} augmented images')

    f.close()
    
    
    rewrite_files(destination_directory, partition)
    copy_images(destination_directory)
    
    delete_temporal_directory()
    print('Done')
    
    
if __name__ == '__main__':
    main()