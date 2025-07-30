<div align="center">

# 🧹 GitHub Repository Cleaner Pro

<div align="center">

![GitHub Repo Cleaner Pro](https://img.shields.io/badge/GitHub-Repo%20Cleaner%20Pro-success?style=for-the-badge&logo=github)
![Version](https://img.shields.io/badge/Version-2.0.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**🚀 Un outil professionnel pour nettoyer intelligemment vos repositories GitHub**

*Suppression sécurisée • Protection automatique • Interface moderne*
<img width="562" height="398" alt="CleanShot 2025-07-30 at 20 56 27" src="https://github.com/user-attachments/assets/dc15e8b9-4dd0-42de-9cb5-336ae0484bf7" />

</div>

---

## ✨ Fonctionnalités

### 🎯 **Modes de nettoyage**
- **🧹 Nettoyage intelligent** - Supprime uniquement les repos de test/demo
- **🛡️ Mode protégé** - Préserve automatiquement les repos épinglés 
- **⚡ Nettoyage agressif** - Garde seulement vos repos importants
- **🔍 Mode analyse** - Scan et recommandations sans suppression

### 🛡️ **Protection avancée**
- ✅ Protection automatique des repos épinglés
- ✅ Liste personnalisée de repos à protéger
- ✅ Sauvegarde des configurations
- ✅ Confirmation obligatoire avant suppression

### 🎨 **Interface moderne**
- 📱 Menu interactif coloré
- 📊 Statistiques en temps réel
- 🎯 Progress bars animés
- 📝 Logs détaillés avec timestamps

---

## 🚀 Installation

### Méthode 1: Clone du repository
```bash
git clone https://github.com/yani2298/github-repo-cleaner-pro.git
cd github-repo-cleaner-pro
chmod +x install.sh && ./install.sh
```

### Méthode 2: Download direct
```bash
curl -O https://raw.githubusercontent.com/yani2298/github-repo-cleaner-pro/main/github-cleaner.sh
chmod +x github-cleaner.sh
```

---

## ⚙️ Configuration

### 1. Token GitHub
```bash
export GITHUB_TOKEN="your_github_token_here"
```

### 2. Configuration personnalisée
Éditez `config/settings.json` :
```json
{
  "username": "your_github_username",
  "protected_repos": [
    "important-project-1",
    "important-project-2"
  ],
  "test_patterns": [
    "test-*",
    "demo-*",
    "*-test"
  ],
  "auto_confirm": false,
  "log_level": "info"
}
```

---

## 📖 Utilisation

### Menu principal
```bash
./github-cleaner.sh
```

### Mode ligne de commande
```bash
# Analyse sans suppression
./github-cleaner.sh --analyze

# Nettoyage intelligent
./github-cleaner.sh --smart-clean

# Nettoyage agressif (dangereux!)
./github-cleaner.sh --aggressive --confirm

# Restaurer un profil GitHub
./github-cleaner.sh --restore-profile

# Afficher les statistiques
./github-cleaner.sh --stats
```

---

## 🛡️ Sécurité

### ⚠️ **Important**
- Les repositories supprimés sont **définitivement perdus**
- Toujours utiliser `--analyze` en premier
- Sauvegarder le code important localement
- Vérifier la liste des repos à supprimer

### 🔒 **Protection automatique**
- Repos épinglés ✅
- Repos avec plus de 10 stars ✅
- Repos modifiés récemment ✅
- Repos dans la liste protégée ✅

---

## 📊 Exemples d'utilisation

### Scénario 1: Premier nettoyage
```bash
# 1. Analyser d'abord
./github-cleaner.sh --analyze

# 2. Nettoyage intelligent
./github-cleaner.sh --smart-clean
```

### Scénario 2: Nettoyage complet
```bash
# Configuration des repos à garder
nano config/settings.json

# Nettoyage agressif
./github-cleaner.sh --aggressive
```

### Scénario 3: Restauration profil
```bash
# Restaurer profil GitHub professionnel
./github-cleaner.sh --restore-profile
```

---

## 🏗️ Structure du projet

```
github-repo-cleaner-pro/
├── 📄 README.md
├── 🚀 github-cleaner.sh          # Script principal
├── ⚙️ install.sh                 # Installation
├── 📁 config/
│   ├── settings.json             # Configuration
│   └── protected-repos.txt       # Repos protégés
├── 📁 modules/
│   ├── analyzer.sh              # Module d'analyse
│   ├── cleaner.sh               # Module de nettoyage
│   ├── protector.sh             # Module de protection
│   └── ui.sh                    # Interface utilisateur
├── 📁 logs/
│   └── cleaner.log              # Fichiers de logs
└── 📁 backup/
    └── deleted-repos.json       # Historique suppressions
```

---

## 🎨 Captures d'écran

### Menu principal
```
╔═══════════════════════════════════════════════════════════════════════╗
║                🧹 GITHUB REPOSITORY CLEANER PRO 🧹                  ║
║                         Version 2.0.0                               ║
╚═══════════════════════════════════════════════════════════════════════╝

┌─ OPTIONS ──────────────────────────────────────────────────────────────┐
│                                                                        │
│  [1] 🔍 Analyser les repositories                                     │
│  [2] 🧹 Nettoyage intelligent                                         │
│  [3] ⚡ Nettoyage agressif                                            │
│  [4] 🛡️ Gérer les protections                                         │
│  [5] 📊 Statistiques                                                   │
│  [6] 🎯 Restaurer profil GitHub                                       │
│  [7] ⚙️ Configuration                                                  │
│  [0] 🚪 Quitter                                                        │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 🤝 Contribution

Les contributions sont les bienvenues ! 

1. **Fork** le projet
2. **Créer** une branche feature (`git checkout -b feature/amazing-feature`)
3. **Commit** vos changements (`git commit -m 'Add amazing feature'`)
4. **Push** sur la branche (`git push origin feature/amazing-feature`)
5. **Ouvrir** une Pull Request

---

## 📝 Changelog

### v2.0.0 (2025-01-01)
- ✨ Interface utilisateur complètement repensée
- 🛡️ Système de protection avancé
- 📊 Statistiques détaillées
- 🎯 Mode restauration de profil
- 📱 Support ligne de commande

### v1.0.0 (2024-12-01)
- 🎉 Version initiale
- 🧹 Nettoyage basique
- 🛡️ Protection repos épinglés

---

## 📄 License

MIT License - voir [LICENSE](LICENSE) pour plus de détails.

---

## 🙏 Remerciements

- **GitHub API** pour l'accès aux données
- **Community** pour les retours et suggestions
- **Contributors** pour leurs améliorations

---

<div align="center">

**⭐ Si ce projet vous aide, n'hésitez pas à lui donner une étoile !**

Made with ❤️ by [Anis Mosbah](https://github.com/yani2298)

</div>
