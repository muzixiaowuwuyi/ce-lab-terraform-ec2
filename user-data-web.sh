#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; background-color: #f4f4f9; }
        h1 { color: #FF9900; }
        p { color: #555; font-size: 18px; }
    </style>
</head>
<body>
    <h1>👋 Welcome to Cloud Engineering Lab!</h1>
    <h2>🚀 Web Server is Up and Running!</h2>
    <h2>GZ Li</h2>
    <p>This standard web page is successfully served by <strong>Apache</strong>.</p>
    <p>EC2 Instance ID: <span style="color: blue;">$INSTANCE_ID</span></p>
</body>
</html>
EOF