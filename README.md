# AgroLink

Architecture Flutter **feature-first**, volontairement simple :

```text
lib/
├── main.dart                         # démarre l'application
├── app.dart                          # configure MaterialApp
├── core/                             # code partagé par plusieurs features
│   └── theme/app_theme.dart
└── features/
    └── home/
        └── presentation/home_page.dart
```

## Ajouter une feature

Crée `features/nom_de_la_feature/presentation/` et place ses pages/widgets dedans.
Ajoute `domain/` seulement s'il existe de vraies règles métier, puis `data/`
seulement si la feature communique avec une API ou une base de données.

Règle simple : le code utilisé par une seule feature reste dans cette feature ;
il va dans `core/` uniquement lorsqu'au moins deux features le partagent.

## Vérifier le projet

```sh
flutter analyze
flutter test
```
