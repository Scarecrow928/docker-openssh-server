#!/bin/bash

# Default values for environment variables
PUID=${PUID:-1000}
PGID=${PGID:-1000}
USER_NAME=${USER_NAME:-user}
USER_PASSWORD=${USER_PASSWORD:-password123}
SSHD_PORT=${SSHD_PORT:-2222}
TZ=${TZ:-UTC}

# Create user if not exists
if ! id -u "$USER_NAME" >/dev/null 2>&1; then
    echo "Creating user $USER_NAME with UID $PUID and GID $PGID"
    groupadd -g "$PGID" "$USER_NAME"
    useradd -u "$PUID" -g "$PGID" -d /config -s /bin/bash "$USER_NAME"
    echo "$USER_NAME:$USER_PASSWORD" | chpasswd
else
    echo "User $USER_NAME already exists, skipping creation"
fi

# Modify sshd configuration to use the port specified by SSHD_PORT environment variable
if grep -q "^#*Port " /etc/ssh/sshd_config; then
    sed -i "s/^#*Port .*/Port $SSHD_PORT/" /etc/ssh/sshd_config
else
    echo "Port $SSHD_PORT" >> /etc/ssh/sshd_config
fi

# Enable password authentication and public key authentication in sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Generate sshd host keys if they do not exist
for key_type in rsa dsa ecdsa ed25519; do
    key_file="/etc/ssh/ssh_host_${key_type}_key"
    if [ ! -f "$key_file" ]; then
        echo "Generating $key_type sshd host key..."
        ssh-keygen -t "$key_type" -f "$key_file" -N ""
    else
        echo "$key_type sshd host key already exists, skipping generation"
    fi
done

# Ensure /run/sshd exists and has the correct permissions
if [ ! -d "/run/sshd" ]; then
    mkdir -p /run/sshd
    echo "/run/sshd directory created"
fi
chown root:root /run/sshd
chmod 0755 /run/sshd
echo "/run/sshd ownership set to root:root and permissions set to 0755"

# Set the timezone
if [ -n "$TZ" ]; then
    echo "Setting timezone to $TZ"
    ln -sf "/usr/share/zoneinfo/$TZ" /etc/localtime
    dpkg-reconfigure -f noninteractive tzdata
else
    echo "No timezone specified, using default system timezone"
fi

# Start sshd service
exec /usr/sbin/sshd -D