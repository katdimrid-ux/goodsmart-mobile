# ARCHITECTURE.md — Goods Mart Mobile (Flutter & Dart — iOS & Android)

## 1. Vision & Stack Technique
Application mobile native cross-platform (iOS et Android) pour **Goods Mart** (commande d'épicerie et ingrédients de cuisine à Legon / Accra).
- **Framework & Langage :** Flutter 3.x (Stable) + Dart 3.x (Null-safety strict).
- **Gestion d'état (State Management) :** `flutter_riverpod` (propre, modulaire, testable).
- **Navigation :** `go_router` (gestion fluide des routes et redirections Auth).
- **Backend & Cloud :** Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore` avec persistance offline activée, `firebase_storage`, `firebase_messaging`).
- **Paiements locaux (Ghana) :** Paystack (MTN MoMo, Telecel Cash, Cartes via WebView/SDK) + Cash on Delivery.
- **Compilation iOS sans Mac :** Codemagic CI/CD (connecté au dépôt GitHub).

## 2. Design System Goods Mart
- **Primary (Marine Blue) :** `Color(0xFF0F172A)`
- **Accent (Island Green) :** `Color(0xFF10B981)`
- **Background :** `Color(0xFFF8FAFC)`
- **Surface / Cartes :** `Color(0xFFFFFFFF)` (BorderRadius `16.0`, ombres douces sans bordures lourdes)
- **UX Spécifique :** Splash screen animé blanc (logo vers panier + slide-up), Header style Bolt/Uber (Drawer menu + sélecteur EN/FR/ZH/JA + icône profil), barre de recherche ergonomique abaissée, carrousels horizontaux de catégories, grille 2 colonnes.

## 3. Structure des Dossiers (`lib/`)
```text
goods_mart_mobile/
├── assets/
│   ├── images/                   # Logo Goods Mart, illustrations
│   └── translations/             # Fichiers JSON (en.json, fr.json, zh.json, ja.json)
├── lib/
│   ├── core/
│   │   ├── constants/            # Couleurs (AppColors), tailles, repères campus Legon
│   │   ├── router/               # Configuration GoRouter (app_router.dart)
│   │   └── theme/                # ThemeData global Material 3 (app_theme.dart)
│   ├── models/                   # Modèles de données Dart (UserModel, ProductModel, OrderModel)
│   ├── services/                 # Appels Firebase & Paystack (auth_service.dart, firestore_service.dart)
│   ├── providers/                # Riverpod Providers (cart_provider.dart, auth_provider.dart, products_provider.dart)
│   ├── screens/                  # Écrans complets
│   │   ├── splash/               # splash_screen.dart (animation logo -> panier)
│   │   ├── auth/                 # login_screen.dart, register_screen.dart
│   │   ├── home/                 # home_screen.dart (Header Bolt, Search, Carrousel, Grille 2 col)
│   │   ├── product/              # product_detail_screen.dart
│   │   ├── cart/                 # cart_screen.dart & checkout_screen.dart
│   │   └── orders/               # orders_screen.dart (suivi temps réel)
│   ├── widgets/                  # Composants UI réutilisables (bolt_header.dart, product_card.dart, category_carousel.dart)
│   └── main.dart                 # Point d'entrée + initialisation Firebase & ProviderScope
├── ARCHITECTURE.md               # Référence projet
└── pubspec.yaml                  # Dépendances Flutter