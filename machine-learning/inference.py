import torch
import torchvision
import torch.nn as nn
from torchvision import transforms
from PIL import Image
import torch.nn.functional as F
import sys
 
class ResNet152(nn.Module):
    def __init__(self):
        super(ResNet152, self).__init__()
        self.resnet = torchvision.models.resnet152()
        self.resnet.fc = nn.Linear(self.resnet.fc.in_features,256)
        self.fc2 = nn.Linear(256,102)
        for name, param in self.resnet.named_parameters():
            param.requires_grad = False
        for name, param in self.fc2.named_parameters():
            param.requires_grad = False
            
    def forward(self, x):
        x = torch.reshape(x,(1,3,224,224))
        x = self.resnet(x)
        x = F.leaky_relu(x)
        x = self.fc2(x)
        return torch.argmax(x,dim=1).item()

transform = transforms.Compose([
    transforms.Resize((224,224)),
    transforms.ToTensor(),
])

def predict():
    if len(sys.argv) < 2:
        print("Please provide the image path name as a command-line argument.")
        sys.exit(1)
    
    image_path = sys.argv[1]
    model = ResNet152()
    model.load_state_dict(torch.load('../machine-learning/resnet150_checkpoint_71acc.pt',map_location=torch.device('cpu')),strict=True)
    model.eval() 
    
    image = Image.open(image_path).convert('RGB')
    image = transform(image)
    
    pred = model(image)
    print(str(pred))    
    
if __name__ == '__main__':
    predict()
    exit(0)
    