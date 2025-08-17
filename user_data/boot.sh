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

yum install audit -y

cat > /etc/audit/rules.d/audit.rules << 'EOF'
-w /etc/passwd -p rwa -k passwd_read_write
-w /etc/shadow -p rwa -k shadow_read_write
-w /etc/group -p rwa -k group_read_write

-w /etc/ssh/sshd_config -p wa -k ssh_config_changes

-a always,exit -F arch=b64 -S execve -F auid>=1000 -F auid!=4294967295 -k sudo_commands
-a always,exit -F arch=b32 -S execve -F auid>=1000 -F auid!=4294967295 -k sudo_commands
EOF

systemctl enable auditd
systemctl start auditd


# Cloudwatch agent
sudo yum install amazon-cloudwatch-agent -y

REGION=$(aws configure get region || curl -s http://169.254.169.254/latest/meta-data/placement/region)

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << EOF
{
  "agent": {
    "metrics_collection_interval": 60,
    "region": "${REGION}",
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
    "debug": false,
    "run_as_user": "cwagent"
  },
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_system",
          "cpu_usage_user"
        ],
        "metrics_collection_interval": 60,
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          "used_percent",
          "free"
        ],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      },
      "mem": {
        "measurement": [
          "mem_used_percent",
          "mem_available_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/secure",
            "log_group_name": "/ec2/secure",
            "log_stream_name": "{instance_id}/secure",
            "timestamp_format": "%b %d %H:%M:%S"
          },
          {
            "file_path": "/var/log/fail2ban.log",
            "log_group_name": "/ec2/fail2ban", 
            "log_stream_name": "{instance_id}/fail2ban",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/ec2/messages",
            "log_stream_name": "{instance_id}/messages", 
            "timestamp_format": "%b %d %H:%M:%S"
          },
          {
            "file_path": "/var/log/audit/audit.log",
            "log_group_name": "/ec2/audit",
            "log_stream_name": "{instance_id}/audit", 
            "timestamp_format": "%b %d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOF

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent