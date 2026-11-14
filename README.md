# SneakerDrop – AWS High-Availability Web Application

## Project Overview

SneakerDrop is a sample sneaker storefront deployed on Amazon Web Services (AWS) to demonstrate high availability, load balancing, automated EC2 provisioning, and infrastructure self-healing.

The project simulates a sneaker retailer preparing for increased website traffic during popular sneaker releases. A single web server could become a point of failure, potentially causing downtime and disrupting customers' shopping experience.

To address this challenge, I designed and deployed an AWS infrastructure environment using an Application Load Balancer (ALB), an Auto Scaling Group (ASG), Amazon EC2, and a Launch Template.

The application runs on Apache web servers across two AWS Availability Zones, helping reduce dependence on a single server or Availability Zone.

I also validated the infrastructure by:

- Sending HTTP requests to confirm traffic was distributed across both EC2 instances.
- Simulating a server failure by terminating an EC2 instance.
- Observing the Auto Scaling Group automatically launch a replacement instance.
- Confirming that the replacement passed the load balancer's health checks and successfully served website traffic.

**AWS Services Used:** Amazon EC2, EC2 Auto Scaling, Elastic Load Balancing (Application Load Balancer), Amazon VPC, and EC2 Launch Templates.
## AWS Architecture

SneakerDrop is deployed in the AWS `us-east-1` region using a Virtual Private Cloud (VPC) spanning two Availability Zones.

The architecture consists of the following components:

### Amazon VPC and Networking
- A custom VPC with the IPv4 CIDR block `10.0.0.0/16`.
- Two public subnets across `us-east-1a` and `us-east-1b`.
- An Internet Gateway and route table providing internet connectivity.
- Security groups controlling HTTP traffic between the Application Load Balancer and EC2 instances.

### Application Load Balancer (ALB)
- An internet-facing Application Load Balancer receives incoming HTTP requests on port 80.
- The ALB forwards requests to the `sneakerdrop-TG` target group.
- Target group health checks determine which EC2 instances are eligible to receive traffic.

### Amazon EC2 and Launch Template
- EC2 `t3.micro` instances host the SneakerDrop application using the Apache HTTP Server.
- Launch Template `sneakerdrop-LT`, Version 2, defines how new instances are provisioned.
- EC2 user data automatically installs Apache, starts the service, and deploys the SneakerDrop HTML landing page.
- Each webpage displays its EC2 instance ID and Availability Zone to help verify traffic distribution.

### EC2 Auto Scaling Group (ASG)
- The `sneakerdrop-asg` Auto Scaling Group maintains a desired capacity of two EC2 instances.
- Minimum capacity: 2 instances.
- Maximum capacity: 5 instances.
- Instances are distributed across two Availability Zones to improve availability.
- If an instance is terminated, the ASG automatically launches a replacement to restore the desired capacity.

### High Availability and Self-Healing
The architecture reduces reliance on a single EC2 instance. If one server fails, the load balancer can route requests to another healthy instance while the Auto Scaling Group provisions a replacement.

This behavior was validated by intentionally terminating an EC2 instance, observing automatic replacement, and confirming that both the replacement and surviving instances successfully served HTTP requests through the ALB.
