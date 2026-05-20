# Security Hardening for ThinkPad T430 OS

This module provides security configurations specifically designed for the ThinkPad T430.

## Security Features

### 1. Kernel Hardening
- Stack protector enabled
- Hardened user copy
- Restrict kernel pointer exposure
- ASLR (Address Space Layout Randomization)

### 2. Network Security
- Firewall rules pre-configured
- SYN flood protection
- ICMP rate limiting
- Port scan detection

### 3. User Security
- Strong password policies
- Account lockout after failed attempts
- Sudo timeout reduction
- Restricted root login

### 4. ThinkPad Security Features
- TPM integration (if available)
- Secure Boot support
- BIOS-level security checks
- Fingerprint reader support (optional)

## Configuration Files

- `firewall.rules` - iptables/nftables rules
- `sysctl-security.conf` - Kernel security parameters
- `pam-configs/` - PAM authentication settings
- `audit-rules/` - System audit configuration

## Quick Setup

```bash
# Apply all security hardening
sudo ./apply-security.sh

# Check security status
./security-audit.py

# View firewall rules
sudo ./show-firewall.sh
```

## Security Levels

Choose your security level in `/etc/t430-security.conf`:
- `balanced` (default) - Good security with minimal performance impact
- `strict` - Maximum security, some convenience features disabled
- `custom` - Define your own settings

## Compliance

This configuration follows best practices from:
- CIS Benchmarks
- STIG guidelines
- NIST recommendations
