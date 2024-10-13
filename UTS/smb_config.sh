#!/bin/bash

# Path to Samba configuration file
SMB_CONF="/etc/samba/smb.conf"

# Define paths for Samba shares
PUBLIC_SHARE="/srv/samba/public"
PRIVATE_SHARE="/srv/samba/private"

# Backup the original configuration file
cp $SMB_CONF "${SMB_CONF}.bak"
echo "Backup of smb.conf created as smb.conf.bak"

# Function to apply recommended settings
apply_recommended_configs() {
    echo "Applying recommended Samba configurations..."

    # General Settings
    echo "Configuring general Samba settings..."
    cat <<EOF >> $SMB_CONF

# Recommended General Settings
[global]
    workgroup = WORKGROUP
    server string = Samba Server %v
    netbios name = $(hostname)
    security = user
    map to guest = Bad User
    dns proxy = no
    log file = /var/log/samba/%m.log
    max log size = 1000
    logging = file
    panic action = /usr/share/samba/panic-action %d
    server role = standalone server
    obey pam restrictions = yes
    unix password sync = yes
    passwd program = /usr/bin/passwd %u
    passwd chat = *Enter\\snew\\sUNIX\\spassword:* %n\\n *Retype\\snew\\sUNIX\\spassword:* %n\\n .
    pam password change = yes
    map to guest = bad user
    usershare allow guests = no
EOF

    # Security Settings
    echo "Configuring security settings..."
    cat <<EOF >> $SMB_CONF

# Recommended Security Settings
    restrict anonymous = 2
    encrypt passwords = true
    passdb backend = tdbsam
    smb encrypt = auto
    client signing = mandatory
    server signing = mandatory
    disable netbios = yes
    ntlm auth = no

    # Disable NT1 protocol (also known as SMB1)
    server min protocol = SMB2
    client min protocol = SMB2

    # Disallow blank passwords
    null passwords = no
EOF

    # Performance Settings
    echo "Configuring performance settings..."
    cat <<EOF >> $SMB_CONF

# Recommended Performance Settings
    socket options = TCP_NODELAY SO_RCVBUF=65536 SO_SNDBUF=65536
    use sendfile = yes
    aio read size = 16384
    aio write size = 16384
    min receivefile size = 16384
    getwd cache = yes
EOF

    # File Sharing Settings
    echo "Configuring file sharing settings..."
    cat <<EOF >> $SMB_CONF

# Recommended File Sharing Settings
[Public]
    path = $PUBLIC_SHARE
    browseable = yes
    guest ok = yes
    read only = no
    create mask = 0775
    directory mask = 0775

[Private]
    path = $PRIVATE_SHARE
    browseable = yes
    guest ok = no
    read only = no
    create mask = 0700
    directory mask = 0700
    valid users = @sambausers
EOF
}

# Function to set correct permissions for Samba shares
set_share_permissions() {
    echo "Setting correct permissions for Samba shares..."

    # Create the Public share directory if it doesn't exist
    if [ ! -d "$PUBLIC_SHARE" ]; then
        mkdir -p $PUBLIC_SHARE
        echo "Created $PUBLIC_SHARE directory."
    fi

    # Set permissions for the Public share
    chmod 0775 $PUBLIC_SHARE
    chown nobody:nogroup $PUBLIC_SHARE
    echo "Set permissions for $PUBLIC_SHARE (0775, owner: nobody, group: nogroup)."

    # Create the Private share directory if it doesn't exist
    if [ ! -d "$PRIVATE_SHARE" ]; then
        mkdir -p $PRIVATE_SHARE
        echo "Created $PRIVATE_SHARE directory."
    fi

    # Set permissions for the Private share
    chmod 0700 $PRIVATE_SHARE
    chown root:sambausers $PRIVATE_SHARE
    echo "Set permissions for $PRIVATE_SHARE (0700, owner: root, group: sambausers)."
}

# Main script execution
apply_recommended_configs
set_share_permissions

echo "Recommended Samba configurations and permissions applied successfully."
