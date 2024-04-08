#/bin/bash

# If sshd host keys doesn't exist, create them
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ] || \
    [ ! -f "/etc/ssh/ssh_host_ecdsa_key" ] || \
    [ ! -f "/etc/ssh/ssh_host_ed25519_key" ]; then
    echo "Generating SSH host keys"
    ssh-keygen -A
fi

# If PORT specified, replace it in sshd_config
if [ -n "$PORT" ]; then
    echo "PORT = $PORT"
    sed -i -E "s/[[:space:]]*#?[[:space:]]*Port[[:space:]]*[[:digit:]]+[[:space:]]*/Port $PORT/g" /etc/ssh/sshd_config
else
    echo "No PORT specified, using default port in /etc/ssh/sshd_config"
fi

# if PASSWORD_AUTHENTICATION is set
if [ "$PASSWORD_AUTHENTICATION" = "yes" ]; then
    echo "Enabling password authentication"
    sed -i -E "s/[[:space:]]*#?[[:space:]]*PasswordAuthentication[[:space:]]*[[:alpha:]]+[[:space:]]*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
else
    echo "Disabling password authentication"
    sed -i -E "s/[[:space:]]*#?[[:space:]]*PasswordAuthentication[[:space:]]*[[:alpha:]]+[[:space:]]*/PasswordAuthentication no/g" /etc/ssh/sshd_config
fi

# Start sshd
echo "Start sshd"
exec /usr/sbin/sshd -D