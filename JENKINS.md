# Step-by-Step Guide: Installing Jenkins on AWS EC2 Using the AWS Management Console

This guide provides detailed instructions to provision a custom **Virtual Private Cloud (VPC)** and launch a **Jenkins** server on an **Amazon EC2** instance through the **AWS Management Console**. The setup follows your exact specifications:

- **VPC CIDR block**: `10.240.0.0/16`
- **Public subnet**: `10.240.1.0/24` (with internet gateway for public access)
- **Private subnet**: `10.240.11.0/24`
- **EC2 instance type**: `t3.xlarge`
- **Root volume size**: 40 GB
- **User data**: The provided `user-data.sh` script (installs Java 21 Amazon Corretto, Terraform, Jenkins, and specified plugins on Amazon Linux 2023)

The Jenkins instance will be launched in the **public subnet** to allow direct access to the Jenkins web interface on port 8080. The private subnet is created for potential future use, such as Jenkins agent nodes.

---

## Prerequisites

- An active AWS account with sufficient permissions for VPC and EC2 services.
- An existing EC2 key pair (create one in the EC2 console if necessary).
- The `user-data.sh` script saved locally as a plain text file.
- Preferred AWS Region (e.g., **us-east-1** for proximity to Northern Virginia).

---

## Deployment Steps

### Step 1: Create the Custom VPC

1. Open the **AWS Management Console** and navigate to the **VPC** service.
2. In the left navigation pane, select **Your VPCs**, then click **Create VPC**.
3. Configure the following:
   - **Resources to create**: VPC only and more (optional)
   - **Name tag**: `jenkins-vpc`
   - **IPv4 CIDR block**: `10.240.0.0/16`
4. Select AZ quantity (1) and availability zone
5. Choose the availability zone closest to you (e.g., `us-east-1a`).
6. Subnet settings: (choose 1 public and 1 private subnet)
   - **Public subnet**: `10.240.1.0/24`
   - **Private subnet**: `10.240.11.0/24`
7. NAT gateway: No NAT gateway (not required for this setup)
8. S3 endpoint: No S3 endpoint (optional, not required for this setup)
9. Enable DNS hostnames and DNS resolution.
10. Review the configuration and click **Create VPC**.

### Step 2: Create Security Group for Jenkins

1. Navigate to the **EC2** console.
2. In the left menu, select **Security Groups**, then click **Create security group**.
3. Configure:
   - **Security group name**: `jenkins-sg`
   - **Description**: Security group for Jenkins server
   - **VPC**: `jenkins-vpc`
4. Add **Inbound rules**:
   - **SSH**: Port 22, Source: Your public IP address (recommended) or `0.0.0.0/0`.
   - **Jenkins Web UI**: Port 8080, Source: `0.0.0.0/0`.
5. Outbound rules: Allow all traffic (default).
6. Review the configuration and click **Create security group**.

### Step 3: Launch the EC2 Instance

1. In the **EC2** console, click **Launch instance**.
2. Configure the instance as follows:

   - **Name**: `jenkins-ec2`
   - **Amazon Machine Image (AMI)**: Amazon Linux 2023 (latest version under Quick Start)
   - **Instance type**: `t3.xlarge`
   - **Key pair**: Select your existing key pair (optional)

   **Network settings**:
   - VPC: `jenkins-vpc`
   - Subnet: `jenkins-public-subnet`
   - Auto-assign public IP: **Enable**
   - Firewall (security groups): Select existing `jenkins-sg`

   **Storage**:
   - Root volume: Change size to **40** GiB (gp3 recommended)

   **Advanced details** (expand section):
   - **User data**: Paste the entire content of `user-data.sh` or upload the file.

3. Review the configuration and click **Launch instance**.

### Step 4: Access and Verify Jenkins

1. In the EC2 console, wait until the instance status is **Running** (allow 5–10 minutes for user data execution).
2. Note the **Public IPv4 address** of the instance.
3. Open a web browser and navigate to:  
   `http://<Public-IP>:8080`
4. Retrieve the initial admin password:
   - Connect via SSH: `ssh -i your-key.pem ec2-user@<Public-IP>`
   - Run: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
5. Paste the password into the Jenkins setup wizard and complete the installation. Pre-installed plugins will be available.

---

**Verification commands** (via SSH):

```bash
sudo systemctl status jenkins
java -version
terraform -version
aws --version
```

---

## Additional Recommendations

- **Security**: For production use, implement an Application Load Balancer (ALB) with HTTPS and restrict direct access to port 8080.
- **IAM Role**: Attach an appropriate IAM role to the instance for Terraform or other AWS service interactions.
- **Monitoring**: Enable Amazon CloudWatch and configure EBS volume snapshots for backups.
- **Cost Management**: Stop the t3.xlarge instance when not in use to control costs.
- **Scaling**: Launch additional instances in the private subnet as Jenkins agents when needed.

This guide ensures a complete, reproducible setup using the AWS Management Console. Should you require any modifications, additional screenshots, or clarification on any step, please provide further details.
