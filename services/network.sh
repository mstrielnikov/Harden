#! /usr/bin/sh

cat >>/etc/sysctl.conf <<EOF
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_redirects  = 0
kernel.exec-shield = 1
kernel.randomize_va_space = 1
net.ipv4.ip_local_port_range = 2000 65000
net.ipv4.tcp_rmem = 4096 87380 8388608
net.ipv4.tcp_wmem = 4096 87380 8388608
net.core.rmem_max = 8388608
net.core.wmem_max = 8388608
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 3
EOF

echo 1 > /proc/sys/net/ipv4/tcp_syncookies
echo 2048 > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo 3 > /proc/sys/net/ipv4/tcp_synack_retries

apt-get update openssh-server

cat >>/etc/ssh/sshd_config <<EOF
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key

Protocol 2

KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com

AuthenticationMethods publickey
PermitEmptyPasswords no
PasswordAuthentication no
PermitRootLogin no
ChallengeResponseAuthentication no
KerberosAuthentication no
GSSAPIAuthentication no
MaxAuthTries 6

ClientAliveInterval 300
ClientAliveCountMax 0
LoginGraceTime 20

LogLevel VERBOSE

UsePrivilegeSeparation sandbox

X11Forwarding no
IgnoreRhosts yes
UseDNS yes
AllowAgentForwarding no
AllowTcpForwarding no
PermitTunnel no
EOF

awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.tmp && mv /etc/ssh/moduli.tmp /etc/ssh/moduli

chown root:root /etc/ssh/sshd_config

chmod 600 /etc/ssh/sshd_config

sudo systemctl restart sshd

sshd -T

exit 0;
