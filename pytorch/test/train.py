from ultralytics import YOLO

yolo = "yolo11n.pt"

model = YOLO(yolo)

train_results = model.train(
    data="C:/Users/erwan/OneDrive/Desktop/Cours/SAE/SAE5.01/pytorch/test/data/data.yaml",
    epochs=5,
    imgsz=640,
    device = 'cpu', project='run', name='result', save_dir='C:/Users/erwan/OneDrive/Desktop/Cours/SAE/SAE5.01/pytorch/test/')

train_results.show()