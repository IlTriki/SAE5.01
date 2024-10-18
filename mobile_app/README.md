# CKOITGROL

## Fonctionnalités actuelles

1. **Authentification**
   - Page de démarrage pour choisir entre la connexion et l'inscription
   - Connexion avec email et mot de passe
   - Inscription avec email et mot de passe
   - Connexion avec Google

2. **Interface utilisateur**
   - Design responsive
   - Support des thèmes clair et sombre

3. **Internationalisation**
   - Support multilingue (actuellement en anglais, français et allemand)

## Technologies et packages utilisés

1. **Framework**
   - [Flutter](https://flutter.dev/)

   *Raison du choix* : Flutter permet un développement rapide et une interface utilisateur cohérente sur iOS et Android avec un seul code base.

2. **Authentification**
   - [Firebase Authentication](https://pub.dev/packages/firebase_auth)
   - [Google Sign-In](https://pub.dev/packages/google_sign_in)

   *Raison du choix* : Firebase offre une solution d'authentification robuste et facile à implémenter, avec la possibilité d'ajouter facilement différentes méthodes de connexion.

3. **Base de données et stockage**
   - [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
   - [Firebase Storage](https://pub.dev/packages/firebase_storage)

   *Raison du choix* : Ces services Firebase offrent une solution de stockage en temps réel et de gestion de fichiers scalable, avec une bonne intégration à Flutter.
   Et c'est gratuit surtout.

4. **Internationalisation**
   - [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)
   - [intl](https://pub.dev/packages/intl)

   *Raison du choix* : Ces packages font partie de l'écosystème officiel de Flutter et offrent une solution robuste pour la gestion des traductions.

5. **Gestion d'état**
   - setState (pour l'instant)

   *Raison du choix* : Pour une application simple, setState est suffisant. Je vais passer à une solution plus robuste (probablement Provider ou GetX) à mesure que l'application se complexifie.

6. **Navigation**
   - Navigation standard de Flutter

   *Raison du choix* : La navigation intégrée de Flutter est suffisante pour les besoins actuels de l'application. Je vais passer à une solution plus avancée (probablement go_router ou GetX) à mesure que l'application se complexifie.

7. **Thème**
   - ThemeData personnalisé pour les thèmes clair et sombre

   *Raison du choix* : L'utilisation de ThemeData permet une personnalisation poussée et cohérente de l'interface utilisateur.

8. **Requêtes réseau**
   - [dio](https://pub.dev/packages/dio)

   *Raison du choix* : Dio offre des fonctionnalités avancées par rapport au package http standard, comme l'interception des requêtes et la gestion des cookies.

9. **Stockage sécurisé**
   - [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)

   *Raison du choix* : Ce package permet de stocker des données sensibles de manière sécurisée sur l'appareil.

10. **Vérification de connexion Internet**
    - [internet_connection_checker](https://pub.dev/packages/internet_connection_checker)

    *Raison du choix* : Ce package offre une méthode fiable pour vérifier la connectivité Internet sur différentes plateformes. Il va etre utile pour verifier si l'utilisateur est connecté à internet avant de faire des requetes au backend.

12. **Autres packages utiles**
    - [flutter_svg](https://pub.dev/packages/flutter_svg)
    - [open_mail_app](https://pub.dev/packages/open_mail_app)
    - [url_launcher](https://pub.dev/packages/url_launcher)
    - [image_picker](https://pub.dev/packages/image_picker)

## Structure du projet

Le projet suit une structure standard pour une application Flutter :

- `lib/` : Contient le code source principal
  - `pages/` : Les différentes pages de l'application
  - `theme/` : Configuration des thèmes
  - `route/` : Logique de routage et garde d'authentification
  - `services/` : Services pour la gestion des données (Firebase, API)
  - `utils/` : Fonctions et classes utilitaires
  - `models/` : Modèles de données
  - `l10n/` : Fichiers de traduction
- `assets/` : Ressources statiques (images, polices)
- `ios/` et `android/` : Configurations spécifiques aux plateformes

Cette structure permet une organisation claire du code et facilite la maintenance et l'évolutivité du projet.

## Configuration

1. **Firebase**
   L'application utilise Firebase pour l'authentification et le stockage. Assurez-vous de configurer Firebase pour votre projet.

2. **Localisation**
   Les fichiers de traduction se trouvent dans le dossier `lib/l10n/`.

3. **Thème**
   La configuration des thèmes se trouve dans `lib/theme/theme.dart`.

## Démarrage

Pour exécuter l'application :

1. Assurez-vous d'avoir Flutter installé sur votre machine.
2. Clonez ce dépôt.
3. Exécutez `flutter pub get` pour installer les dépendances.
4. Lancez l'application avec `flutter run`.

## Prochaines étapes

- Implémentation de fonctionnalités supplémentaires, notamment :
  - Intégration d'un modèle d'intelligence artificielle pour le scan en temps réel d'images
  - Fonctionnalité de partage d'images scannées entre utilisateurs

- Amélioration de la gestion d'état :
  - Transition vers une solution plus robuste comme Provider ou Bloc pour gérer la complexité croissante de l'application

- Optimisation du routage :
  - Considération de l'utilisation de [go_router](https://pub.dev/packages/go_router) pour une gestion plus avancée des routes

  *Raison du choix potentiel* : Go Router offre une solution de routage déclarative qui s'intègre bien avec les applications Flutter complexes. Il permet une gestion efficace des routes imbriquées, des paramètres de route, et supporte la navigation basée sur les deeplinks, ce qui pourrait être utile pour le partage d'images scannées. De plus, il offre une meilleure performance pour les applications de grande taille par rapport au système de navigation par défaut de Flutter.

- Ajout de tests unitaires et d'intégration pour assurer la stabilité de l'application

- Optimisation des performances, particulièrement pour le traitement en temps réel des images

- Amélioration de l'expérience utilisateur, notamment pour le processus de scan et de partage d'images

- Considération de l'utilisation de [GetX](https://pub.dev/packages/get) comme alternative pour la gestion d'état et le routage

  *Raison du choix potentiel* : GetX offre une solution tout-en-un pour la gestion d'état, le routage et la gestion des dépendances. Il pourrait simplifier le code et améliorer les performances, ce qui serait bénéfique pour une application avec un traitement intensif comme le scan d'images en temps réel.

- Considération de l'ajout de fonctionnalités sociales pour améliorer l'engagement des utilisateurs autour du partage d'images scannées
