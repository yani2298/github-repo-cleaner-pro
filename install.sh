#!/bin/bash

# 🚀 INSTALLATION GITHUB REPOSITORY CLEANER PRO
# Script d'installation automatique

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} ✅ $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} ⚠️ $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} ❌ $1"; }

show_banner() {
    echo -e "${PURPLE}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════╗
║             🚀 INSTALLATION GITHUB CLEANER PRO 🚀                   ║
║                         Version 2.0.0                               ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
}

check_requirements() {
    log_info "🔍 Vérification des prérequis..."
    
    local missing_deps=()
    local required_commands=("curl" "grep" "sed" "git")
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -eq 0 ]; then
        log_success "Tous les prérequis sont installés"
    else
        log_error "Commandes manquantes: ${missing_deps[*]}"
        log_info "Veuillez installer les dépendances manquantes"
        exit 1
    fi
}

setup_directories() {
    log_info "📁 Création de la structure des dossiers..."
    
    mkdir -p config modules logs backup
    
    log_success "Structure des dossiers créée"
}

setup_permissions() {
    log_info "🔐 Configuration des permissions..."
    
    chmod +x github-cleaner.sh
    
    # Rendre exécutables les scripts existants s'ils existent
    for script in cleanup_repos_*.sh *.sh; do
        if [ -f "$script" ]; then
            chmod +x "$script"
        fi
    done
    
    log_success "Permissions configurées"
}

create_symlink() {
    log_info "🔗 Création du lien symbolique..."
    
    local install_dir="/usr/local/bin"
    local script_path="$(pwd)/github-cleaner.sh"
    
    # Vérifier si nous avons les permissions pour créer le symlink
    if [ -w "$install_dir" ]; then
        ln -sf "$script_path" "$install_dir/github-cleaner"
        log_success "Lien symbolique créé: github-cleaner"
        log_info "Vous pouvez maintenant utiliser 'github-cleaner' depuis n'importe où"
    else
        log_warning "Impossible de créer le lien symbolique (permissions insuffisantes)"
        log_info "Utilisez: sudo $0 pour l'installation globale"
        log_info "Ou utilisez directement: ./github-cleaner.sh"
    fi
}

setup_configuration() {
    log_info "⚙️ Configuration initiale..."
    
    if [ ! -f "config/settings.json" ]; then
        # Créer la configuration par défaut
        cat > config/settings.json << 'EOF'
{
  "username": "yani2298",
  "protected_repos": [
    "Anis-Mosbah-Portfolio",
    "PlayOuran",
    "GoGreenPro",
    "MuslimHub",
    "salat-now"
  ],
  "test_patterns": [
    "test-*",
    "demo-*",
    "*-test",
    "hello-world",
    "*-demo",
    "achievements-unlocked",
    "pull-shark-demo-*",
    "pair-extraordinaire-demo",
    "*badge*test*"
  ],
  "auto_confirm": false,
  "log_level": "info",
  "backup_before_delete": true,
  "protect_starred_repos": true,
  "min_stars_protection": 5,
  "protect_recent_repos": true,
  "recent_days_threshold": 30
}
EOF
        log_success "Configuration par défaut créée"
    else
        log_info "Configuration existante conservée"
    fi
}

check_github_token() {
    log_info "🔑 Vérification du token GitHub..."
    
    if [ -z "${GITHUB_TOKEN:-}" ]; then
        log_warning "GITHUB_TOKEN non configuré"
        echo ""
        echo -e "${YELLOW}Pour utiliser toutes les fonctionnalités, configurez votre token GitHub:${NC}"
        echo "1. Allez sur: https://github.com/settings/tokens"
        echo "2. Créez un nouveau token avec les permissions 'repo'"
        echo "3. Exportez-le: export GITHUB_TOKEN=\"votre_token\""
        echo "4. Ajoutez-le à votre ~/.bashrc ou ~/.zshrc pour le rendre permanent"
        echo ""
    else
        log_success "Token GitHub configuré"
    fi
}

show_completion() {
    echo ""
    echo -e "${GREEN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════╗
║                    🎉 INSTALLATION TERMINÉE 🎉                      ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo "🚀 GitHub Repository Cleaner Pro est maintenant installé !"
    echo ""
    echo -e "${BLUE}UTILISATION:${NC}"
    echo "  ./github-cleaner.sh          # Menu interactif"
    echo "  ./github-cleaner.sh --help   # Aide complète"
    echo ""
    echo -e "${BLUE}PROCHAINES ÉTAPES:${NC}"
    echo "  1. Configurez votre GITHUB_TOKEN"
    echo "  2. Éditez config/settings.json si nécessaire" 
    echo "  3. Lancez ./github-cleaner.sh"
    echo ""
    echo -e "${PURPLE}Made with ❤️ by Anis Mosbah${NC}"
}

main() {
    show_banner
    check_requirements
    setup_directories
    setup_permissions
    create_symlink
    setup_configuration
    check_github_token
    show_completion
}

main "$@"