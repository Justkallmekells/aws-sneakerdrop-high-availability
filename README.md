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
