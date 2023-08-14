# Jenkins Pipeline README

This Jenkins pipeline is designed to automate the deployment process for a project to both a test server and a production server. The pipeline consists of several stages, each with specific steps to be executed.

## Configuration

Before using the pipeline, make sure to configure the following:

- **Jenkins**: Ensure that you download jenkins on your ubuntu.
- **AWS CLI**: Ensure that the AWS CLI is installed and configured on the Jenkins machine.
- **SSH Key**: Update the SSH key path and filename ("/var/lib/jenkins/or2.pem") with the appropriate SSH key for accessing the test and production servers.
- **AWS Region**: Modify the AWS region ("eu-central-1") according to your desired region.
- **S3 Bucket**: Adjust the S3 bucket name ("jenkins-test-or1") to match your own S3 bucket for storing the tar.gz file.
- **GitHub Repository**: Update the GitHub repository URL ("https://github.com/Orelbaz/jenkins-test.git") with your own repository URL.
- **Tags**: Modify the tag values ("test" and "prod") based on the specific EC2 instance tags you are using for the test and production servers.

## Pipeline Overview

The pipeline performs the following stages:

1. Cleanup: Performs cleanup operations by removing all files in the current workspace.
2. Build: Clones the project repository, packages it into a tar.gz file, and uploads it to an S3 bucket.
3. Test-server: Deploys the project to a test server and runs tests on it.
4. Approve: Waits for manual approval to proceed with the deployment to the production server.
5. Prod-server: If approved, deploys the project to the production server.

## Pipeline Steps

### Cleanup

- Removes all files in the current workspace.

### Build

- Clones the project repository from the specified GitHub URL.
- Packages the cloned repository into a tar.gz file.
- Uploads the tar.gz file to an S3 bucket named "jenkins-test-or1".

### Test-server

- SSHs into the test server using the provided SSH key and IP address.
- Downloads the tar.gz file from the S3 bucket.
- Extracts the contents of the tar.gz file.
- Removes the tar.gz file.
- Executes the deployment script located in the cloned repository.
- Runs tests using the Testing.sh script in the cloned repository.

### Approve

- Waits for manual approval to proceed with the deployment to the production server. If auto-approval is desired, the input line should be commented out.

### Prod-server

- SSHs into the production server using the provided SSH key and IP address.
- Downloads the tar.gz file from the S3 bucket.
- Extracts the contents of the tar.gz file.
- Removes the tar.gz file.
- Executes the deployment script located in the cloned repository.
