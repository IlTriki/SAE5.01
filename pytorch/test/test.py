from ultralytics import YOLO

#model_perso = "/home/manchoy/Dev/github/SAE5.01/runs/detect/train5/weights/best.pt"
yolo = "yolo11n.pt"

model = YOLO(yolo)

img = '../dataset/shoeTypeClassifierDataset/training/sneakers/image1.jpg'
video = '/home/manchoy/Téléchargements/videoshoes.mp4'



results = model(img, save=True, show=True, project='run', name='result', save_dir='/home/manchoy/Dev/github/SAE5.01/pytorch/test/')

input("Appuyez sur Entrée pour continuer...")