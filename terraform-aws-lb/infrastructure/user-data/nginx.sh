#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y nginx

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

HOSTNAME=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/hostname)

PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/local-ipv4)

AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
<title>Terraform Demo</title>
<style>
body {
    font-family: Arial;
    margin-top: 40px;
    text-align: center;
    background: #f4f4f4;
}
.card {
    background: white;
    padding: 30px;
    width: 600px;
    margin: auto;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,.2);
}
</style>
</head>

<body>

<div class="card">

<h1>Hello World</h1>

<h2>Served by NGINX</h2>

<p><b>Instance ID:</b> $INSTANCE_ID</p>

<p><b>Hostname:</b> $HOSTNAME</p>

<p><b>Availability Zone:</b> $AZ</p>

<p><b>Private IP:</b> $PRIVATE_IP</p>

</div>

</body>

</html>
EOF

systemctl enable nginx
systemctl restart nginx