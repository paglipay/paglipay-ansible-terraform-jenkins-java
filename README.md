# CI/CD Deployment Using Ansible CM Tool

## Course-end Project 1

### Description

As a DevOps engineer at XYZ Ltd., you are tasked with automating the deployment of a Java application using Ansible as the Configuration Management (CM) tool. The goal is to integrate Ansible with Jenkins CI server, allowing the automation of the deployment process for WAR files on Tomcat/Jetty web containers. This README.md file serves as documentation for the course project.

### Steps to Perform

1. **Configure Jenkins Server as Ansible Provisioning Machine:**
   - Set up Jenkins as the Ansible provisioning machine to enable the execution of Ansible playbooks.

2. **Install Ansible Plugins in Jenkins CI Server:**
   - Ensure that the necessary Ansible plugins are installed on the Jenkins CI server to facilitate seamless integration.

3. **Prepare Ansible Playbook to Run Maven Build on Jenkins CI Server:**
   - Create an Ansible playbook that orchestrates the Maven build process on the Jenkins CI server.

4. **Prepare Ansible Playbook to Execute Deployment Steps on Remote Web Container with Restart:**
   - Develop an Ansible playbook for deploying custom WAR files to a web container, followed by the restart of the web container.

### Terraform Configuration (main.tf)

The project includes Terraform configuration to provision infrastructure on AWS for hosting the Java application. Here's an overview of the main components:

- **Providers:**
  - AWS provider is configured with the necessary credentials and region.

- **Data:**
  - Retrieves the latest Amazon Linux AMI using AWS Systems Manager Parameter Store.

- **Resources:**
  - Defines VPC, internet gateway, public subnet, route table, and associates the subnet with the route table.
  - Configures security groups for Nginx, allowing various ports for HTTP access.
  - Creates an EC2 instance (nginx1) with the specified configuration, including provisioning scripts.

### Jenkinsfile

The Jenkinsfile defines the Jenkins pipeline with the following stages:

1. **Checkout:**
   - Clones the project repository from GitHub.

2. **Plan:**
   - Initializes Terraform and generates a plan for infrastructure changes.

3. **Approval:**
   - If auto-approval is not enabled, prompts for manual approval based on the generated Terraform plan.

4. **Apply:**
   - Applies the Terraform changes, deploying the infrastructure.

### Usage

1. **Jenkins Configuration:**
   - Configure Jenkins with Ansible and the necessary plugins.
   - Set up Jenkins credentials for AWS access.

2. **Run Jenkins Pipeline:**
   - Trigger the Jenkins pipeline, providing required parameters such as AWS credentials and the desired action (apply/destroy).
   - Approve the plan if manual approval is required.

3. **Monitor Deployment:**
   - Monitor Jenkins console output for the progress of the deployment.
   - Check AWS console for provisioned infrastructure.

### Additional Notes

- The project assumes the presence of Ansible playbooks and templates in the specified directories.

Feel free to customize the Ansible playbooks, Terraform configuration, and Jenkins pipeline to suit your specific requirements.

**Note:** Ensure that sensitive information such as AWS credentials and private keys is handled securely and not exposed in public repositories.
