import torch
import torchvision
import torch.nn as nn
from torch.utils.mobile_optimizer import optimize_for_mobile
from torchvision import transforms
import numpy as np
from PIL import Image
import torch.onnx
import onnx
import torch.nn.functional as F
 
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
        return x



if __name__ == '__main__':
    model = ResNet152()
    model.load_state_dict(torch.load('resnet150_checkpoint_71acc.pt',map_location=torch.device('cpu')),strict=True)
    model.eval() 
    dummy_input = torch.randn(3, 224, 224,dtype=torch.float32)
    
    torch.onnx.export(model,
                    dummy_input, 
                    "resnet152_71acc.onnx",
                    input_names=['model_input_tensor'],
                    export_params=True,
                    output_names=['model_output_tensor'],
                    verbose=True)
    print(" ") 
    print('Model has been converted to ONNX')
    import onnx

    try:
        onnx_model = onnx.load("resnet152_71acc.onnx")
        onnx.checker.check_model(onnx_model,full_check=True)
        print('ONNX check passed')
    except Exception as e:
        print('ONNX check failed: {}'.format(e))