# Projet SAE 5.01 : Reconnaissance des Chaussures

![Flutter](https://img.shields.io/badge/Flutter-UI-blue)
![PyTorch](https://img.shields.io/badge/PyTorch-IA-orange)
![Firebase](https://img.shields.io/badge/Firebase-DB-yellow)

## :dart: Description
Ce projet vise à développer une application mobile de reconnaissance et de classification de chaussures en temps réel en utilisant des techniques de vision par ordinateur et d’apprentissage profond. L'application permet aux utilisateurs de capturer des images de chaussures ou d’utiliser le flux vidéo de la caméra pour identifier et classer des chaussures en différentes catégories.

## :fountain_pen: Equipe ##

- <a href="https://github.com/NathanChampes" target="_blank">CHAMPES Nathan</a>
- <a href="https://github.com/nicolamenace" target="_blank">MADEC Nicolas</a>
- <a href="https://github.com/Adamas955" target="_blank">TERMOTE Erwan</a>
- <a href="https://github.com/IlTriki/" target="_blank">TRIKI Osama</a>

## Fonctionnalités
1. **Acquisition d'images** :
   - Capture d’images et de vidéos via la caméra en temps réel.
   - Import d'images depuis la galerie de l'utilisateur.

2. **Reconnaissance d'objets** :
   - Utilisation d'un modèle de reconnaissance d'objets pré-entraîné pour identifier les chaussures.
   - Affichage des résultats en temps réel.

3. **Base de données** :
   - Intégration d'une base de données de catégories d'objets.

4. **Auth** :
   - Intégration de Firebase pour permettre l'authentification Google ainsi que l'authentification par mail.

5. **Interface utilisateur** :
   - Interface intuitive permettant de capturer des images, visualiser les résultats, et consulter l'historique des reconnaissances.
   - Visualisation des prédictions sous forme de pourcentage de confiance pour chaque chaussure reconnue.

6. **Fonctionnalités supplémentaires** :
   - Sauvegarde des images et des résultats pour consultation ultérieure.
   - Stockage des résultats dans une base de données en ligne (Firebase) permettant le partage entre utilisateurs.

## :rocket: Technologies Utilisées
- **Front-end** : Flutter
- **Back-end et IA** :
  - **Modèle IA** : YOLOv11 
  - **Framework de Deep Learning** : PyTorch
  - **Base de données et Authentification** : Firebase

## :white_check_mark: Prérequis
- **Flutter** : [Installation](https://flutter.dev/docs/get-started/install)
- **Python** et **PyTorch** : [Installation de PyTorch](https://pytorch.org/get-started/locally/)
- **Firebase** : [Installation](https://firebase.google.com/docs/flutter/setup) [Choix de Firebase](https://docs.google.com/document/d/1RXeCvwl9rg1jxLRxyLL1OSE61ktS39gc4aDN_pnFVvE/edit?usp=sharing)

## :checkered_flag: Installation
1. **Clonez le dépôt GitHub** :
   ```bash
   git clone https://github.com/IlTriki/SAE5.01.git
   cd SAE5.01
   ```
2. **Installez les dépendances Flutter** :
   ```bash
   cd ckoitgrol
   flutter pub get
   dart run build_runner build
   flutter gen-l10n
   ```
  Ne oubliez pas de configurer Firebase pour votre projet en suivant les instructions dans la documentation Firebase.

  Lancez l'application :
   ```bash
   flutter run
   ```
