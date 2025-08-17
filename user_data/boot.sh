yum update -y


# Fail 2 BAN
yum install epel-release -y
yum install fail2ban -y

sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

cat >> /etc/fail2ban/jail.local << 'EOF'

# Jump server security settings
[DEFAULT]
bantime  = 1h
findtime = 20m  
maxretry = 3

[sshd]
enabled = true
port = 22
logpath = /var/log/secure
maxretry = 3
bantime = 1h

[recidive]
enabled = true
logpath = /var/log/fail2ban.log
banaction = %(banaction_allports)s
bantime = 1w
findtime = 1d
maxretry = 3

[ssh-ddos]
enabled = true
port = 22
logpath = /var/log/secure
maxretry = 6
findtime = 300
bantime = 600
filter = sshd-ddos

EOF

systemctl enable fail2ban
systemctl start fail2ban

# SSHD CONFIG
cat >> /etc/ssh/sshd-banner << 'EOF'
     |\    o
    |  \    o
|\ /    .\ o
| |       (
|/ \     /
    |  /
     |/

BASTION HOST  v.1 
EOF

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 5/' /etc/ssh/sshd_config

cat >> /etc/ssh/sshd_config << 'EOF'

# Additional hardening
ChallengeResponseAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
Banner /etc/ssh/sshd-banner
ClientAliveInterval 300
ClientAliveCountMax 1

EOF

sshd -t && systemctl restart sshd

# Cloudwatch agent
# sudo yum install amazon-cloudwatch-agent





