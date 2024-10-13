#!/bin/bash

# Backup the current sysctl.conf file
SYSCTL_CONF="/etc/sysctl.conf"
BACKUP_CONF="/etc/sysctl.conf.backup.$(date +%Y%m%d%H%M%S)"
sudo cp "$SYSCTL_CONF" "$BACKUP_CONF"

echo "Backup of current sysctl.conf created at $BACKUP_CONF."

# Define the kernel parameters
KERNEL_PARAMS=(
  # Network security settings
  "net.ipv4.tcp_syncookies=1"
  "net.ipv4.tcp_rfc1337=1"
  "net.ipv4.conf.all.rp_filter=1"
  "net.ipv4.conf.default.rp_filter=1"
  "net.ipv4.conf.all.accept_redirects=0"
  "net.ipv4.conf.default.accept_redirects=0"
  "net.ipv4.conf.all.secure_redirects=0"
  "net.ipv4.conf.default.secure_redirects=0"
  "net.ipv6.conf.all.accept_redirects=0"
  "net.ipv6.conf.default.accept_redirects=0"
  "net.ipv4.conf.all.send_redirects=0"
  "net.ipv4.conf.default.send_redirects=0"
  "net.ipv4.icmp_echo_ignore_all=1"
  "net.ipv4.conf.all.accept_source_route=0"
  "net.ipv4.conf.default.accept_source_route=0"
  "net.ipv6.conf.all.accept_source_route=0"
  "net.ipv6.conf.default.accept_source_route=0"
  "net.ipv6.conf.all.accept_ra=0"
  "net.ipv6.conf.default.accept_ra=0"
  "net.ipv4.tcp_sack=0"
  "net.ipv4.tcp_dsack=0"
  "net.ipv4.tcp_fack=0"
  
  # Kernel security settings
  "kernel.kptr_restrict=2"
  "kernel.dmesg_restrict=1"
  "kernel.printk=3 3 3 3"
  "kernel.unprivileged_bpf_disabled=1"
  "net.core.bpf_jit_harden=2"
  "dev.tty.ldisc_autoload=0"
  "vm.unprivileged_userfaultfd=0"
  "kernel.kexec_load_disabled=1"
  "kernel.sysrq=1"
  "kernel.unprivileged_userns_clone=0"
  "kernel.perf_event_paranoid=3"
  "kernel.yama.ptrace_scope=2"
  "kernel.watchdog=1"
  "kernel.yama.ptrace_scope=3"


  # Filesystem protection
  "fs.protected_symlinks=1"
  "fs.protected_hardlinks=1"

  # ASLR settings
  "vm.mmap_rnd_bits=32"
  "vm.mmap_rnd_compat_bits=16"
)

# Apply kernel parameters
for param in "${KERNEL_PARAMS[@]}"; do
  if ! grep -q "^${param%=*}" "$SYSCTL_CONF"; then
    echo "$param" | sudo tee -a "$SYSCTL_CONF"
  else
    sudo sed -i "s|^${param%=*}.*|$param|" "$SYSCTL_CONF"
  fi
done

# Apply the changes immediately
sudo sysctl -p

echo "Kernel parameters have been updated and applied."
