from ultralytics import YOLO


model = YOLO("/home/manchoy/Dev/github/SAE5.01/pytorch/test/run/result2/weights/best.pt") 


model.export(format="tflite")