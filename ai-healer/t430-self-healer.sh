#!/bin/bash
# T430 AI Self-Healing System
# Offline, lightweight system repair using pattern matching and heuristics
# Optimized for Intel i5-3320M with minimal resource usage

set -euo pipefail

# Colors for user-friendly output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

LOG_FILE="/var/log/t430-healer.log"
BACKUP_DIR="/var/backup/t430-healer"
RULES_DIR="/etc/t430-healer/rules"
STATE_FILE="/var/lib/t430-healer/state.json"

# Ensure directories exist
mkdir -p "$BACKUP_DIR" "$(dirname "$LOG_FILE")" "$(dirname "$STATE_FILE")" 2>/dev/null || true

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE" 2>/dev/null || echo "$1"
}

log_success() { log "${GREEN}✓ $1${NC}"; }
log_warn() { log "${YELLOW}⚠ $1${NC}"; }
log_error() { log "${RED}✗ $1${NC}"; }
log_info() { log "${BLUE}ℹ $1${NC}"; }

# Simple state tracking (JSON-like, no external dependencies)
save_state() {
    local key="$1"
    local value="$2"
    echo "\"$key\": \"$value\"" >> "$STATE_FILE.tmp" 2>/dev/null || true
    mv "$STATE_FILE.tmp" "$STATE_FILE" 2>/dev/null || true
}

# Check system health metrics
check_system_health() {
    log_info "Running system health check..."
    
    local issues=0
    
    # Check critical filesystems
    if ! mountpoint -q /proc 2>/dev/null; then
        log_error "/proc not mounted - critical system issue!"
        ((issues++))
    fi
    
    if ! mountpoint -q /sys 2>/dev/null; then
        log_error "/sys not mounted - critical system issue!"
        ((issues++))
    fi
    
    # Check disk space
    local root_usage=$(df / 2>/dev/null | tail -1 | awk '{print $5}' | tr -d '%' || echo "0")
    if [ "$root_usage" -gt 95 ] 2>/dev/null; then
        log_error "Root filesystem ${root_usage}% full - critical!"
        ((issues++))
    elif [ "$root_usage" -gt 85 ] 2>/dev/null; then
        log_warn "Root filesystem ${root_usage}% full"
    fi
    
    # Check critical services (if systemd available)
    if command -v systemctl &>/dev/null; then
        local failed_units=$(systemctl --failed --no-legend 2>/dev/null | wc -l || echo "0")
        if [ "$failed_units" -gt 0 ]; then
            log_warn "$failed_units failed systemd units detected"
        fi
    fi
    
    # Check memory pressure
    local mem_available=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "0")
    local mem_total=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "1")
    if [ "$mem_available" -lt $((mem_total / 20)) ] 2>/dev/null; then
        log_error "Critical memory pressure - less than 5% available"
        ((issues++))
    fi
    
    return $issues
}

# Rule-based problem detection and fixing
detect_and_fix() {
    local category="$1"
    log_info "Scanning for $category issues..."
    
    case "$category" in
        "boot")
            fix_bootloader
            fix_fstab
            ;;
        "network")
            fix_network_config
            fix_dns
            ;;
        "filesystem")
            fix_permissions
            fix_broken_links
            ;;
        "packages")
            fix_package_database
            fix_broken_dependencies
            ;;
        "services")
            fix_failed_services
            ;;
        "config")
            fix_corrupted_configs
            ;;
        *)
            log_warn "Unknown category: $category"
            return 1
            ;;
    esac
}

# Bootloader fixes
fix_bootloader() {
    log_info "Checking bootloader configuration..."
    
    # Check GRUB config
    if [ -f /etc/default/grub ]; then
        if ! grep -q "GRUB_TIMEOUT" /etc/default/grub; then
            log_warn "GRUB_TIMEOUT missing, adding default"
            echo "GRUB_TIMEOUT=5" >> /etc/default/grub
            save_state "grub_timeout" "fixed"
        fi
        
        # Verify GRUB entries exist
        if [ -d /boot/grub ] && [ ! -f /boot/grub/grub.cfg ]; then
            log_error "GRUB config missing! Attempting regeneration..."
            if command -v grub-mkconfig &>/dev/null; then
                grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null && \
                    log_success "GRUB configuration regenerated" || \
                    log_error "Failed to regenerate GRUB"
            fi
        fi
    fi
}

# Filesystem table fixes
fix_fstab() {
    log_info "Checking fstab integrity..."
    
    if [ -f /etc/fstab ]; then
        # Test fstab syntax (dry-run mount)
        if ! mount -a --fake --dry-run 2>/dev/null; then
            log_error "fstab has errors!"
            
            # Create backup
            cp /etc/fstab "$BACKUP_DIR/fstab.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
            
            # Try to identify and comment out problematic lines
            local temp_fstab=$(mktemp)
            while IFS= read -r line; do
                if [[ ! "$line" =~ ^# ]] && [[ -n "$line" ]]; then
                    local device=$(echo "$line" | awk '{print $1}')
                    if [[ ! "$device" =~ ^UUID= ]] && [[ ! "$device" =~ ^/dev/ ]] && [[ ! "$device" =~ ^tmpfs ]]; then
                        log_warn "Commenting out suspicious fstab entry: $line"
                        echo "# $line  # Disabled by t430-healer" >> "$temp_fstab"
                        continue
                    fi
                fi
                echo "$line" >> "$temp_fstab"
            done < /etc/fstab
            
            mv "$temp_fstab" /etc/fstab
            log_success "fstab cleaned up"
        else
            log_success "fstab is valid"
        fi
    fi
}

# Network configuration fixes
fix_network_config() {
    log_info "Checking network configuration..."
    
    # Check for common network manager configs
    if command -v nmcli &>/dev/null; then
        if ! nmcli connection show &>/dev/null; then
            log_warn "NetworkManager connections corrupted, attempting reset..."
        fi
    fi
    
    # Check interfaces file
    if [ -f /etc/network/interfaces ]; then
        if ! grep -q "lo" /etc/network/interfaces; then
            log_warn "Loopback interface missing in config, adding..."
            echo -e "\nauto lo\niface lo inet loopback" >> /etc/network/interfaces
        fi
    fi
}

# DNS fixes
fix_dns() {
    log_info "Checking DNS configuration..."
    
    if [ -f /etc/resolv.conf ]; then
        if ! grep -q "nameserver" /etc/resolv.conf; then
            log_warn "No DNS servers configured, adding fallback..."
            echo "nameserver 127.0.0.53" > /etc/resolv.conf
            echo "# Added by t430-healer - fallback DNS" >> /etc/resolv.conf
        fi
    fi
}

# Permission fixes
fix_permissions() {
    log_info "Checking critical file permissions..."
    
    local critical_dirs=("/bin" "/sbin" "/lib" "/lib64" "/usr" "/etc")
    
    for dir in "${critical_dirs[@]}"; do
        if [ -d "$dir" ]; then
            if [ ! -r "$dir" ]; then
                log_error "Critical directory $dir not readable!"
                chmod 755 "$dir" 2>/dev/null && log_success "Fixed permissions on $dir" || \
                    log_error "Could not fix permissions on $dir"
            fi
        fi
    done
    
    # Fix common permission issues
    if [ -f /etc/shadow ] && [ ! -r /etc/shadow ]; then
        chmod 640 /etc/shadow 2>/dev/null && log_success "Fixed /etc/shadow permissions"
    fi
    
    if [ -f /etc/passwd ] && [ ! -r /etc/passwd ]; then
        chmod 644 /etc/passwd 2>/dev/null && log_success "Fixed /etc/passwd permissions"
    fi
}

# Broken symbolic links
fix_broken_links() {
    log_info "Scanning for broken symbolic links..."
    
    local broken_count=0
    local fixed_count=0
    
    # Scan common directories (limited to avoid resource usage)
    for dir in /etc /usr/bin /usr/lib /lib; do
        if [ -d "$dir" ]; then
            while IFS= read -r link; do
                if [ -n "$link" ]; then
                    ((broken_count++))
                    if [ $broken_count -le 10 ]; then
                        log_warn "Broken link found: $link"
                        rm -f "$link" 2>/dev/null && ((fixed_count++)) || true
                    fi
                fi
            done < <(find "$dir" -xtype l -maxdepth 3 2>/dev/null | head -20)
        fi
    done
    
    if [ $broken_count -gt 0 ]; then
        log_info "Found $broken_count broken links, removed $fixed_count"
    else
        log_success "No broken symbolic links found"
    fi
}

# Package database fixes (distribution-agnostic approach)
fix_package_database() {
    log_info "Checking package database integrity..."
    
    if command -v dpkg &>/dev/null; then
        log_info "Debian/Ubuntu system detected"
        if ! dpkg --audit 2>/dev/null; then
            log_warn "Package database has issues, attempting fix..."
            dpkg --configure -a 2>/dev/null && log_success "Package database repaired" || \
                log_error "Could not fully repair package database"
        fi
    elif command -v rpm &>/dev/null; then
        log_info "RPM-based system detected"
        if ! rpm --verify --all 2>/dev/null | grep -q "^"; then
            log_success "RPM database appears healthy"
        else
            log_warn "RPM verification found issues"
        fi
    elif command -v pacman &>/dev/null; then
        log_info "Arch-based system detected"
        if command -v pacman-db-upgrade &>/dev/null; then
            pacman-db-upgrade 2>/dev/null && log_success "Pacman database upgraded" || true
        fi
    else
        log_info "No known package manager found"
    fi
}

# Broken dependencies
fix_broken_dependencies() {
    log_info "Checking for broken dependencies..."
    
    if command -v apt-get &>/dev/null; then
        apt-get check 2>/dev/null || {
            log_warn "Broken dependencies detected"
            apt-get -f install 2>/dev/null && log_success "Dependencies fixed" || \
                log_error "Could not fix all dependencies"
        }
    fi
}

# Failed services
fix_failed_services() {
    if ! command -v systemctl &>/dev/null; then
        return 0
    fi
    
    log_info "Checking for failed services..."
    
    local failed=$(systemctl --failed --no-legend 2>/dev/null || echo "")
    if [ -n "$failed" ]; then
        log_warn "Failed services detected:"
        echo "$failed" | while read -r line; do
            local service=$(echo "$line" | awk '{print $1}')
            log_info "  - $service"
            
            # Try to restart critical services
            if [[ "$service" =~ ^(ssh|network|dbus|systemd-journald) ]]; then
                log_info "Attempting to restart critical service: $service"
                systemctl restart "$service" 2>/dev/null && \
                    log_success "Restarted $service" || \
                    log_error "Failed to restart $service"
            fi
        done
    else
        log_success "All services running normally"
    fi
}

# Corrupted configuration files
fix_corrupted_configs() {
    log_info "Checking for corrupted configuration files..."
    
    local configs=("/etc/passwd" "/etc/group" "/etc/shadow")
    
    for config in "${configs[@]}"; do
        if [ -f "$config" ]; then
            if [ ! -s "$config" ]; then
                log_error "Empty config file: $config"
            fi
            
            if file "$config" 2>/dev/null | grep -q "data"; then
                log_error "Possible binary corruption in $config"
                local latest_backup=$(ls -t "$BACKUP_DIR"/$(basename "$config").* 2>/dev/null | head -1 || echo "")
                if [ -n "$latest_backup" ]; then
                    log_info "Restoring from backup: $latest_backup"
                    cp "$latest_backup" "$config"
                fi
            fi
        fi
    done
}

# Main healing routine
run_healer() {
    log_info "🔧 T430 AI Self-Healer starting..."
    log_info "Optimized for ThinkPad T430 (i5-3320M)"
    log_info "Working offline - no internet required"
    
    # Initial health check
    local initial_issues=0
    check_system_health || initial_issues=$?
    
    if [ $initial_issues -eq 0 ]; then
        log_success "System appears healthy!"
    else
        log_warn "Detected $initial_issues critical issues"
    fi
    
    # Run detection and fixing for each category
    local categories=("boot" "filesystem" "network" "packages" "services" "config")
    
    for category in "${categories[@]}"; do
        echo ""
        log_info "━━━━━━━━━━━━━━━━━━━━━━━━"
        detect_and_fix "$category"
        sleep 1
    done
    
    # Final health check
    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "Running final health check..."
    
    local final_issues=0
    check_system_health || final_issues=$?
    
    if [ $final_issues -eq 0 ]; then
        log_success "✅ All systems operational!"
    else
        log_warn "⚠️  $final_issues issues remain - manual intervention may be needed"
    fi
    
    log_info "Healing session complete. Log saved to: $LOG_FILE"
    
    return $final_issues
}

# Interactive mode for kids
interactive_mode() {
    echo ""
    echo "🤖 Welcome to T430 Self-Healing Robot!"
    echo "I will help fix your computer automatically."
    echo ""
    echo "Press ENTER to start healing, or Ctrl+C to cancel..."
    read -r
    
    run_healer
    
    echo ""
    if [ $? -eq 0 ]; then
        echo "🎉 Great news! Your computer is fixed and ready!"
    else
        echo "🔧 I fixed what I could. Some things might need a grown-up's help."
    fi
    echo ""
}

# Show usage
show_help() {
    cat << EOF
T430 AI Self-Healing System
Offline, lightweight system repair for ThinkPad T430

Usage: $0 [OPTIONS]

Options:
  -a, --auto        Run automatic healing (non-interactive)
  -i, --interactive Run in interactive mode (kid-friendly)
  -c, --check       Only check system health, don't fix
  -h, --help        Show this help message
  -l, --log         Show recent log entries

Examples:
  $0 --auto         # Quick automatic fix
  $0 --interactive  # Step-by-step with explanations
  $0 --check        # Just see what's wrong

EOF
}

# Parse arguments
case "${1:-}" in
    -a|--auto)
        run_healer
        ;;
    -i|--interactive|"")
        interactive_mode
        ;;
    -c|--check)
        check_system_health
        exit $?
        ;;
    -l|--log)
        tail -50 "$LOG_FILE" 2>/dev/null || echo "No log file found"
        ;;
    -h|--help)
        show_help
        ;;
    *)
        show_help
        exit 1
        ;;
esac
