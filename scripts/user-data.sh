#!/bin/bash

# Retrieve EC2 instance information using IMDSv2
TOKEN=$(curl -fsS -X PUT \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
  http://169.254.169.254/latest/api/token)

INSTANCE_ID=$(curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

AZ=$(curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Update the system packages
dnf update -y

# Install the Apache web server (httpd)
dnf install -y httpd

# Start the Apache service and enable it to start on boot
systemctl start httpd
systemctl enable httpd

# Create the custom HTML landing page
cat << EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sneaker Drop</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f172a, #1e293b);
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }
        .container {
            max-width: 600px;
            padding: 40px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 16px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            letter-spacing: -1px;
            background: linear-gradient(90deg, #38bdf8, #818cf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        p {
            font-size: 1.1rem;
            color: #94a3b8;
            line-height: 1.6;
        }
        .badge {
            display: inline-block;
            margin-top: 25px;
            padding: 8px 16px;
            background: #38bdf8;
            color: #0f172a;
            font-weight: bold;
            border-radius: 20px;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .cartoon-shoes {
          display: flex;
          justify-content: center;
          gap: 20px;
          margin-top: 30px;
        }
        .shoe-card {
          width: 150px;
          background: rgba(255, 255, 255, 0.1);
          padding: 15px;
          border-radius: 10px;
        }
        .shoe-card img {
          width: 100%;
          height: auto;
          border-radius: 5px;
        }
        .shoe-name {
          margin-top: 10px;
          font-weight: bold;
          color: #38bdf8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Sneaker Drop</h1>
        <p>Where the most popular shoes come here first.</p>
        <div class="cartoon-shoes">
          <div class="shoe-card">
            <img src="http://placekitten.com/g/150/150" alt="Cartoon Sneaker 1">
            <div class="shoe-name">The 'Toon Kicks'</div>
          </div>
          <div class="shoe-card">
            <img src="http://placekitten.com/150/150" alt="Cartoon Sneaker 2">
            <div class="shoe-name">Cosmic Crawlers</div>
          </div>
        </div>
        <div class="badge">Live & Deployed</div>
<p>EC2 Instance: $INSTANCE_ID</p>
<p>Availability Zone: $AZ</p>
    </div>
</body>
</html>
EOF

# Set appropriate permissions for the web directory
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
