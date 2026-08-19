# AgroLink CM

AgroLink CM connecte directement les agriculteurs camerounais vérifiés aux
acheteurs : particuliers, restaurants, hôtels, supermarchés et grossistes.
L'application couvre la découverte, les échanges, la commande, le paiement
compatible Mobile Money et la confirmation de livraison.

Le lancement cible Yaoundé, puis Douala, Bafoussam, Bamenda, Garoua et
l'Afrique centrale.

## Modules disponibles

- Authentification locale : connexion, inscription et choix du profil acheteur ou agriculteur.
- Accueil : recherche, catégories et aperçu des produits disponibles à Yaoundé.

> L'authentification actuelle valide uniquement le parcours dans l'application.
> Elle devra être reliée à l'API lorsque le contrat backend sera disponible.

## Architecture

Architecture Flutter **feature-first**, volontairement simple :

```text
lib/
├── main.dart                         # démarre l'application
├── app.dart                          # configure MaterialApp
├── core/                             # code partagé par plusieurs features
│   └── theme/app_theme.dart
└── features/
    └── <feature>/
        ├── presentation/             # pages
        ├── controller/               # état et actions
        ├── widgets/                  # widgets de la feature
        └── models/                   # modèles de la feature
```

## Ajouter une feature

Crée les dossiers `presentation/`, `controller/`, `widgets/` et `models/` dans
chaque feature. Ajoute `domain/` seulement s'il existe de vraies règles métier,
puis `data/` seulement si la feature communique avec une API ou une base.

Règle simple : le code utilisé par une seule feature reste dans cette feature ;
il va dans `core/` uniquement lorsqu'au moins deux features le partagent.

Toute évolution du produit, d'un module ou de l'architecture doit mettre cette
documentation à jour.

## Vérifier le projet

```sh
flutter analyze
flutter test
```
