import onnx
model_path = 'resnet152_71acc_2.onnx'
onnx_model = onnx.load(model_path)
import numpy as np
import torch 
from PIL import Image
import cv2 as cv
import onnxruntime as ort
from torchvision import transforms
img = cv.imread('/home/mircea/IS/augmentare_1000_102/ip102_v1.1/images/09274.jpg')
cv.imshow('image',img)
cv.waitKey(0)
cv.destroyAllWindows()

transform = transforms.Compose([
    transforms.ToPILImage(),
    transforms.Resize((224,224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=0,
        std=1)])
img = transform(img)    
# img = np.array(img)
# cv.imshow('image',img)
# cv.waitKey(0)
# cv.destroyAllWindows()
print(img)

# Create an ONNX Runtime inference session
session = ort.InferenceSession(model_path)
input_name = session.get_inputs()[0].name
output_name = session.get_outputs()[0].name
# Run inference
outputs = session.run([output_name],{input_name: img},run_options=None)

print(outputs)
