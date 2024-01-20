# CI/CD Deployment Using Ansible CM Tool with Jenkins

In modern software development, Continuous Integration (CI) and Continuous Deployment (CD) play a crucial role in ensuring the efficiency, reliability, and rapid delivery of software. Jenkins, a widely used open-source automation server, is commonly employed in CI/CD pipelines to automate various stages of the software development lifecycle. This writeup will guide you through a Jenkins pipeline that leverages the Ansible Configuration Management (CM) tool for deployment.


### Project Source Code - https://github.com/paglipay/paglipay-ansible-terraform-jenkins-java.git

## Jenkinsfile Overview

The provided Jenkinsfile outlines a CI/CD pipeline with stages for checking out source code, planning infrastructure changes using Terraform, obtaining approval, and applying the changes. Additionally, it includes a section for running Ansible playbooks on the newly created AWS virtual machine (VM). Let's break down the key components of the Ansible playbook and how it's integrated into the pipeline.

### Pipeline Parameters

The pipeline begins by defining parameters that users can customize when triggering the pipeline:

- `autoApprove`: A boolean parameter to determine whether to automatically apply changes after generating the Terraform plan.
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`: AWS credentials required for interacting with AWS services.
- `action`: A choice parameter to specify whether to 'apply' or 'destroy' infrastructure.

### Environment Variables

Next, the pipeline sets up environment variables using the specified parameters. These variables include AWS credentials and Terraform variables required for the deployment process.

### Stages

1. **Checkout:**
   - The pipeline starts by checking out the source code from a Git repository (`https://github.com/paglipay/paglipay-ansible-terraform-jenkins-java.git`) into the 'terraform' directory.

2. **Plan:**
   - Initializes Terraform and generates a plan (`tfplan`) for the infrastructure changes.

3. **Approval:**
   - This stage includes a conditional step that checks whether automatic approval is enabled (`autoApprove == true`). If not, it prompts the user for approval before proceeding.

4. **Apply:**
   - Applies the Terraform changes, either creating or destroying infrastructure based on the specified action (`apply` or `destroy`).

5. **Run Ansible Playbook:**
   - After the infrastructure is provisioned, the pipeline runs an Ansible playbook to configure the newly created AWS VM. The playbook performs various tasks, including:
     - Installing Java and Tomcat on the VM.
     - Setting up Tomcat as a systemd service.
     - Installing Git and cloning a Git repository.
     - Installing Maven and building a Java application.
     - Copying the WAR file to Tomcat's webapps directory.

### How to Use

To use this Jenkinsfile:

1. Configure Jenkins: Set up a Jenkins instance with the necessary plugins, including the AWS credentials plugin, Git plugin, and the Terraform plugin.
2. Create a new pipeline job in Jenkins.
3. Copy and paste the provided Jenkinsfile into the pipeline script section.
4. Save the job configuration and trigger the pipeline.

### Conclusion

This Jenkinsfile demonstrates a comprehensive CI/CD pipeline that integrates Ansible for configuration management and Terraform for infrastructure provisioning. Customize the parameters, stages, and Ansible playbook according to your project requirements, and enhance the pipeline to include additional steps such as testing, security scanning, and deployment to production environments.
