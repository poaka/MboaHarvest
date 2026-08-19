# Instructions pour les agents IA

Ces règles sont obligatoires pour toute modification de ce dépôt.

## Architecture

Le projet utilise une Clean Architecture **feature-first**, volontairement simple :

```text
lib/
├── main.dart
├── app.dart
├── core/
└── features/
    └── <feature>/
        ├── presentation/
        ├── domain/       # seulement si la feature a des règles métier
        └── data/         # seulement si la feature utilise une source externe
```

- `main.dart` démarre uniquement l'application.
- `app.dart` contient la configuration globale de `MaterialApp`.
- `core/` reçoit uniquement du code réellement partagé par au moins deux features et ne dépend jamais d'une feature.
- Un client HTTP générique partagé peut aller dans `core/network/`; les appels et DTO propres à une feature restent dans son dossier `data/`.
- Chaque écran, widget et état propre à une feature reste dans sa feature.
- Une feature commence avec `presentation/`. Ne pas créer `domain/` ou `data/` vides.
- `domain/` contient les entités, règles métier et interfaces de repository.
- `data/` contient les DTO, sources de données et adapters de repository.
- `presentation/` peut dépendre de `domain/`; `data/` peut dépendre de `domain/`.
- Quand `domain/` et `data/` existent, `presentation/` ne dépend pas directement de `data/`.
- `domain/` ne dépend ni de Flutter, ni de `presentation/`, ni de `data/`.
- `core/` peut contenir du code Flutter partagé, comme le thème, mais aucun code métier propre à une feature.
- Une feature ne doit jamais importer une autre feature. `app.dart` peut importer leurs pages d'entrée pour la navigation et assembler leurs dépendances concrètes.

## Simplicité obligatoire

- Réutiliser l'existant avant de créer un nouveau module.
- Ne pas ajouter de repository, use case, interface, factory ou abstraction sans besoin réel.
- Ne pas ajouter de package ou de gestionnaire d'état sans justification fonctionnelle.
- Ne pas créer de dossiers vides ou de code prévu « pour plus tard ».
- Garder la modification dans le plus petit nombre de fichiers possible.

## Avant de terminer

1. Lire `README.md`, `pubspec.yaml` et les fichiers de la feature concernée.
2. Rechercher les modules existants avant d'en ajouter.
3. Formater avec `dart format lib test`.
4. Exécuter `flutter analyze` puis les tests Flutter concernés.
5. Mettre à jour `README.md` si la structure de l'architecture change.

Nom du package Dart : `agrolink`. Identifiant d'application : `com.agrolink.app`.
