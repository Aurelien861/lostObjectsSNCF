# Objets trouvés SNCF

## Contexte et objectifs
Cette appli permet aux clients de la SNCF d'avoir accès aux objets trouvés dans les trains. 
Les utilisateurs peuvent alors rechercher si un objet qu'ils ontp perdu a été retrouvé par un employé de la SNCF. Il peut appliquer des filtres à sa recherche (date, gare de départ, type d'objet, nature de l'objet).

Lorsque l'utilisateur ouvre l'application, les premiers objets affichés sont les derniers objets trouvés par agents SNCF qui sont dénombrés et séparés des objets déjà consultés par l'utilisateur.

## Réalisation d'une maquette
Pour répondre aux objectifs de ce projet tout en proposant une bonne expérience utilisateur, nous avons décidé de commencer par implémenter une maquette interractive sur Figma dont voici le lien: https://www.figma.com/proto/QT12CM63s6mmlZC0EoBf4I/SNCF?t=EdU4usD95j4lGCOZ-1&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&node-id=1-2

Bien que nous avions exploré les fonctionnalités que nous offrait l'api avant de réaliser la maquette, nous avons été contraint de modifier certaines fonctionnalités qui n'étaient pas implémentables avec les données que nous expose l'API. Il s'agit cependant de petits détails et l'applicaiton que nous avons développé est en grande partie conforme à cette maquette.

## Choix d'implémentation

### Utilisation de provider
Comme dans le projet 2048, nous avons implémenté un provider qui gère en temps réel les objets trouvés à afficher sur l'écran en fonction des filtres.

### Architecture du projet
Pour une meilleur lisibilité et maintenabilité du code, nous avons choisi de respecter une architecture de projet classique en séparant les composants dans différents dossiers.

Le dossier model contient les modèles de données utilisés, notamment les modèles d'objets correspondant à ceux que l'on reçoit depuis l'API.

Le dossier services qui contient les différents services permettant de communiquer avec l'API. Ces services sont appelés par le provider afin de récupérer les données. Ce service utilise le package http qui permet nous permet de former et d'envoyer les requêtes http vers l'api et d'en recevoir la réponse. Ce dossier service est théoriquement responsable de la gestion des règles métiers. Ce n'est pas exactement le cas dans ce projet puisque nous avons délégué une partie des règles métiers (notamment la gestion des filtres) au provider; il s'agit d'un point que nous pourrons améliorer lors des prochains projets.

Le dossier views contient les différentes parties de l'interface graphique. Ce dossier est lui même découpé en 2 dossiers pages et widgets, qui comme leurs noms l'indique, permettent de séparer les pages des widgets qui les composent.

Un dossier utils qui contient certaines fonctions pratiques dont nous avons eu besoin à plusieurs reprises dans ce projet: récupération des images, des couleurs...
A noter qu'il est possible d'éclater ce dossier en pluisieurs dossiers (en créeant un dossier theme pour la gestion des couleurs par exemple) mais au vu de la taille raisonnable du projet, nous avons trouvé cela cohérent de placer ces fonctions dans un dossier commun.