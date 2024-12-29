from ultralytics import YOLO

model_perso = (
    "/home/manchoy/Dev/github/SAE5.01/pytorch/test/run/result2/weights/best.pt"
)
yolo = "yolo11n.pt"

model = YOLO(model_perso)

img = "../test/data/train/images/-3-_jpg.rf.0e7f0aa6c8c98af08d97186aa1c70c60.jpg"
chat = "/home/manchoy/Téléchargements/chat.jpg"
perso = "/home/manchoy/Téléchargements/Chaussure.jpg"
nicolas = "/home/manchoy/Téléchargements/nicolas.jpeg"
video = "/home/manchoy/Téléchargements/videoshoes.mp4"

results = model(
    perso,
    save=True,
    show=True,
    project="run",
    name="result",
    save_dir="/home/manchoy/Dev/github/SAE5.01/pytorch/test/",
)

input("Appuyez sur Entrée pour continuer...")
