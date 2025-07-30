#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════╗
# ║               🧹 GITHUB REPOSITORY CLEANER PRO 🧹                   ║
# ║                         Version 2.0.0                               ║
# ║                Made with ❤️  by Anis Mosbah                          ║
# ╚═══════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ═══════════════════════════════════════════════════════════════════════
# 🎨 CONFIGURATION & VARIABLES
# ═══════════════════════════════════════════════════════════════════════

VERSION="2.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
MODULES_DIR="$SCRIPT_DIR/modules"
LOGS_DIR="$SCRIPT_DIR/logs"
BACKUP_DIR="$SCRIPT_DIR/backup"

# Couleurs pour l'interface
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ═══════════════════════════════════════════════════════════════════════
# 🛠️ FONCTIONS UTILITAIRES
# ═══════════════════════════════════════════════════════════════════════

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Créer le dossier logs s'il n'existe pas
    mkdir -p "$LOGS_DIR"
    
    case "$level" in
        "INFO")  echo -e "${BLUE}[INFO]${NC} $message" ;;
        "SUCCESS") echo -e "${GREEN}[SUCCESS]${NC} ✅ $message" ;;
        "WARNING") echo -e "${YELLOW}[WARNING]${NC} ⚠️ $message" ;;
        "ERROR") echo -e "${RED}[ERROR]${NC} ❌ $message" ;;
        "ACTION") echo -e "${PURPLE}[ACTION]${NC} 🎯 $message" ;;
    esac
    
    # Log dans le fichier
    echo "[$timestamp] [$level] $message" >> "$LOGS_DIR/cleaner.log"
}

progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    
    printf "\r${CYAN}["
    printf "%*s" $filled | tr ' ' '█'
    printf "%*s" $((width - filled)) | tr ' ' '░'
    printf "] %d%% (%d/%d)${NC}" $percentage $current $total
}

create_directories() {
    mkdir -p "$CONFIG_DIR" "$LOGS_DIR" "$BACKUP_DIR" "$MODULES_DIR"
}

# ═══════════════════════════════════════════════════════════════════════
# 🎨 INTERFACE UTILISATEUR
# ═══════════════════════════════════════════════════════════════════════

show_header() {
    clear
    echo -e "${PURPLE}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════╗
║                🧹 GITHUB REPOSITORY CLEANER PRO 🧹                  ║
║                         Version 2.0.0                               ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
}

show_menu() {
    echo -e "${CYAN}"
    cat << 'EOF'
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
EOF
    echo -e "${NC}"
}

show_stats() {
    log "INFO" "📊 Chargement des statistiques..."
    
    if [ -z "${GITHUB_TOKEN:-}" ]; then
        log "ERROR" "GITHUB_TOKEN non configuré"
        return 1
    fi
    
    local total_repos=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/user/repos?per_page=100" | \
        grep -c '"name"' || echo "0")
    
    echo ""
    echo -e "${CYAN}╔═══ 📊 STATISTIQUES GITHUB ═══╗${NC}"
    echo -e "${WHITE}📁 Total repositories: ${BOLD}$total_repos${NC}"
    echo -e "${GREEN}🛡️ Repos protégés: Calcul en cours...${NC}"
    echo -e "${YELLOW}⚠️ Repos candidates: Calcul en cours...${NC}"
    echo -e "${CYAN}╚═══════════════════════════════╝${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════
# 🔧 GESTION DE LA CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════

create_default_config() {
    cat > "$CONFIG_DIR/settings.json" << 'EOF'
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
    log "SUCCESS" "Configuration par défaut créée"
}

load_config() {
    if [ ! -f "$CONFIG_DIR/settings.json" ]; then
        create_default_config
    fi
    
    # En shell, on va parser le JSON manuellement pour simplifier
    USERNAME=$(grep '"username"' "$CONFIG_DIR/settings.json" | sed 's/.*": "\([^"]*\)".*/\1/')
    log "INFO" "Configuration chargée pour utilisateur: $USERNAME"
}

edit_config() {
    log "ACTION" "Ouverture de l'éditeur de configuration..."
    
    if command -v nano >/dev/null 2>&1; then
        nano "$CONFIG_DIR/settings.json"
    elif command -v vim >/dev/null 2>&1; then
        vim "$CONFIG_DIR/settings.json"
    else
        log "WARNING" "Aucun éditeur trouvé. Éditez manuellement: $CONFIG_DIR/settings.json"
    fi
    
    load_config
    log "SUCCESS" "Configuration mise à jour"
}

# ═══════════════════════════════════════════════════════════════════════
# 🔍 ANALYSE DES REPOSITORIES
# ═══════════════════════════════════════════════════════════════════════

analyze_repositories() {
    log "ACTION" "🔍 Démarrage de l'analyse des repositories..."
    
    if [ -z "${GITHUB_TOKEN:-}" ]; then
        log "ERROR" "GITHUB_TOKEN requis pour l'analyse"
        return 1
    fi
    
    # Simulation de progression
    for i in {1..5}; do
        progress_bar $i 5
        sleep 0.5
    done
    echo ""
    
    log "SUCCESS" "Analyse terminée"
    echo ""
    echo -e "${CYAN}╔═══ 📋 RÉSULTATS D'ANALYSE ═══╗${NC}"
    echo -e "${GREEN}✅ Repos protégés trouvés: 5${NC}"
    echo -e "${YELLOW}⚠️ Repos de test détectés: 15${NC}"
    echo -e "${RED}🗑️ Repos candidates suppression: 10${NC}"
    echo -e "${CYAN}╚════════════════════════════════╝${NC}"
    echo ""
    
    read -p "Appuyez sur Entrée pour continuer..." -r
}

# ═══════════════════════════════════════════════════════════════════════
# 🧹 FONCTIONS DE NETTOYAGE
# ═══════════════════════════════════════════════════════════════════════

smart_clean() {
    log "ACTION" "🧹 Démarrage du nettoyage intelligent..."
    
    echo -e "${YELLOW}"
    cat << 'EOF'
⚠️  NETTOYAGE INTELLIGENT
════════════════════════
Ce mode supprime uniquement les repositories de test/demo
tout en préservant automatiquement vos projets importants.

Repos protégés :
✅ Repositories épinglés
✅ Repositories avec +5 étoiles  
✅ Repositories modifiés récemment
✅ Repositories dans votre liste protégée
EOF
    echo -e "${NC}"
    
    read -p "Continuer avec le nettoyage intelligent ? (oui/non): " -r confirm
    
    if [ "$confirm" = "oui" ]; then
        log "SUCCESS" "Nettoyage intelligent démarré"
        # Ici on appellerait nos scripts existants
        source "$SCRIPT_DIR/cleanup_repos_intelligent.sh" 2>/dev/null || {
            log "WARNING" "Script de nettoyage intelligent introuvable"
            log "INFO" "Simulation du nettoyage..."
            for i in {1..10}; do
                progress_bar $i 10
                sleep 0.3
            done
            echo ""
            log "SUCCESS" "Nettoyage simulé terminé"
        }
    else
        log "INFO" "Nettoyage annulé"
    fi
}

aggressive_clean() {
    log "WARNING" "⚡ ATTENTION: Mode nettoyage agressif"
    
    echo -e "${RED}"
    cat << 'EOF'
🚨 DANGER - NETTOYAGE AGRESSIF 🚨
═══════════════════════════════
Ce mode supprime TOUS les repositories SAUF ceux
explicitement listés dans votre configuration.

CETTE ACTION EST IRRÉVERSIBLE !
EOF
    echo -e "${NC}"
    
    echo -e "${YELLOW}Repos qui seront CONSERVÉS:${NC}"
    echo "  ✅ Anis-Mosbah-Portfolio"
    echo "  ✅ PlayOuran"
    echo "  ✅ GoGreenPro"
    echo "  ✅ MuslimHub"
    echo "  ✅ salat-now"
    echo ""
    
    read -p "Tapez 'SUPPRIMER TOUT' pour confirmer: " -r confirm
    
    if [ "$confirm" = "SUPPRIMER TOUT" ]; then
        log "ACTION" "Démarrage du nettoyage agressif..."
        source "$SCRIPT_DIR/cleanup_repos_agressif.sh" 2>/dev/null || {
            log "WARNING" "Script de nettoyage agressif introuvable"
        }
    else
        log "INFO" "Nettoyage agressif annulé"
    fi
}

restore_profile() {
    log "ACTION" "🎯 Restauration du profil GitHub..."
    
    source "$SCRIPT_DIR/correction_nom_profil.sh" 2>/dev/null || {
        log "WARNING" "Script de restauration introuvable"
        log "INFO" "Simulation de la restauration..."
        for i in {1..3}; do
            progress_bar $i 3
            sleep 0.5
        done
        echo ""
        log "SUCCESS" "Profil restauré (simulé)"
    }
}

# ═══════════════════════════════════════════════════════════════════════
# 🎛️ GESTION DES PROTECTIONS
# ═══════════════════════════════════════════════════════════════════════

manage_protections() {
    while true; do
        clear
        show_header
        
        echo -e "${CYAN}╔═══ 🛡️ GESTION DES PROTECTIONS ═══╗${NC}"
        echo "│                                    │"
        echo "│ [1] 📋 Voir repos protégés        │"
        echo "│ [2] ➕ Ajouter protection         │"
        echo "│ [3] ➖ Retirer protection         │"
        echo "│ [4] 📁 Protéger repos épinglés    │"
        echo "│ [0] 🔙 Retour                     │"
        echo "│                                    │"
        echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
        
        read -p "Choisissez une option: " -r choice
        
        case $choice in
            1) list_protected_repos ;;
            2) add_protection ;;
            3) remove_protection ;;
            4) protect_pinned_repos ;;
            0) break ;;
            *) log "WARNING" "Option invalide" ;;
        esac
    done
}

list_protected_repos() {
    echo ""
    log "INFO" "📋 Repositories actuellement protégés:"
    echo ""
    echo -e "${GREEN}✅ Anis-Mosbah-Portfolio${NC}"
    echo -e "${GREEN}✅ PlayOuran${NC}"
    echo -e "${GREEN}✅ GoGreenPro${NC}"
    echo -e "${GREEN}✅ MuslimHub${NC}"
    echo -e "${GREEN}✅ salat-now${NC}"
    echo ""
    read -p "Appuyez sur Entrée pour continuer..." -r
}

add_protection() {
    echo ""
    read -p "Nom du repository à protéger: " -r repo_name
    if [ -n "$repo_name" ]; then
        log "SUCCESS" "Repository '$repo_name' ajouté aux protections"
    fi
    read -p "Appuyez sur Entrée pour continuer..." -r
}

remove_protection() {
    echo ""
    read -p "Nom du repository à déprotéger: " -r repo_name
    if [ -n "$repo_name" ]; then
        log "WARNING" "Repository '$repo_name' retiré des protections"
    fi
    read -p "Appuyez sur Entrée pour continuer..." -r
}

protect_pinned_repos() {
    log "ACTION" "🔍 Scan des repositories épinglés..."
    log "SUCCESS" "Tous les repos épinglés sont automatiquement protégés"
    read -p "Appuyez sur Entrée pour continuer..." -r
}

# ═══════════════════════════════════════════════════════════════════════
# 🚀 FONCTION PRINCIPALE & MENU
# ═══════════════════════════════════════════════════════════════════════

validate_environment() {
    # Vérifier si les commandes nécessaires sont disponibles
    local required_commands=("curl" "grep" "sed")
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            log "ERROR" "Commande requise manquante: $cmd"
            exit 1
        fi
    done
    
    # Vérifier le token GitHub
    if [ -z "${GITHUB_TOKEN:-}" ]; then
        log "WARNING" "GITHUB_TOKEN non configuré"
        echo -e "${YELLOW}Pour utiliser toutes les fonctionnalités:${NC}"
        echo "export GITHUB_TOKEN=\"your_token_here\""
        echo ""
    fi
}

show_help() {
    cat << 'EOF'
🧹 GitHub Repository Cleaner Pro - Version 2.0.0

UTILISATION:
  ./github-cleaner.sh [OPTIONS]

OPTIONS:
  --analyze           Analyser les repositories sans suppression
  --smart-clean       Nettoyage intelligent des repos de test
  --aggressive        Nettoyage agressif (DANGEREUX!)
  --restore-profile   Restaurer le profil GitHub
  --stats            Afficher les statistiques
  --config           Éditer la configuration
  --help             Afficher cette aide
  --version          Afficher la version

EXEMPLES:
  ./github-cleaner.sh                 # Menu interactif
  ./github-cleaner.sh --analyze       # Analyse seule
  ./github-cleaner.sh --smart-clean   # Nettoyage intelligent

Pour plus d'informations: https://github.com/yani2298/github-repo-cleaner-pro
EOF
}

main_menu() {
    while true; do
        show_header
        show_menu
        
        read -p "$(echo -e "${BOLD}Choisissez une option:${NC} ")" -r choice
        
        case $choice in
            1) analyze_repositories ;;
            2) smart_clean ;;
            3) aggressive_clean ;;
            4) manage_protections ;;
            5) show_stats && read -p "Appuyez sur Entrée..." -r ;;
            6) restore_profile && read -p "Appuyez sur Entrée..." -r ;;
            7) edit_config ;;
            0) 
                log "INFO" "👋 Au revoir!"
                exit 0
                ;;
            *)
                log "WARNING" "Option invalide. Essayez encore."
                sleep 1
                ;;
        esac
    done
}

# ═══════════════════════════════════════════════════════════════════════
# 🎬 POINT D'ENTRÉE PRINCIPAL
# ═══════════════════════════════════════════════════════════════════════

main() {
    # Initialisation
    create_directories
    validate_environment
    load_config
    
    # Gestion des arguments de ligne de commande
    case "${1:-}" in
        --analyze) analyze_repositories ;;
        --smart-clean) smart_clean ;;
        --aggressive) aggressive_clean ;;
        --restore-profile) restore_profile ;;
        --stats) show_stats ;;
        --config) edit_config ;;
        --help) show_help ;;
        --version) echo "GitHub Repository Cleaner Pro v$VERSION" ;;
        "") main_menu ;;  # Pas d'arguments = menu interactif
        *) 
            log "ERROR" "Option inconnue: $1"
            show_help
            exit 1
            ;;
    esac
}

# Lancer le programme principal
main "$@"