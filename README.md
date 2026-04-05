# Jenkins Build Using Webhook and Run Terraform Script

## Prerequisites

- Jenkins running on EC2
- Jenkins reachable from the internet (e.g. `http://<EC2-PUBLIC-IP>:8080`)
- Jenkins Git plugin installed
- Jenkins AWS Credentials plugin installed
- Repo with Jenkinsfile and terraform script
- Github and git plugins

---

## Jenkinsfile

A simple declarative [**Jenkinsfile**](Jenkinsfile):

- Clones git repo
- Binds AWS IAM user creds in terraform stages with AWS Creds plugin
- Stages for terraform init and apply
- Destroy stage using user input

---

## Terraform File

- A simple [**AWS S3 bucket**](test-bucket.tf) is deployed
- S3 bucket name uniqueness is guaranteed

---

## User data

[**EC2 startup script**](user-data.sh) to bootstrap Jenkins server

---

## Jenkins Pipeline Demo

<https://github.com/user-attachments/assets/69bd49f1-2700-4e2e-9a1e-77234b25baad>

---

## Snyk IaC Demo

<https://github.com/user-attachments/assets/69bd49f1-2700-4e2e-9a1e-77234b25baad>

- [**Snyk Report:**](https://app.snyk.io/org/daquietstorm22/project/7f7d6689-611a-4a40-865f-9e2d733a78fa)

---

## Artifacts

- **Suge WAF Output**
- ![suge-waf.jpg](/images/suge-waf.jpg)
- **Jenkins Pipeline Output**
  -![jenkins-pipeline.jpg](/images/jenkins-pipeline.jpg)
- **Jenkins Webhook Output**
  - ![jenkins-webhook.jpg](/images/jenkins-webhook.jpg)
- **S3 Bucket Output**
  - ![s3-bucket.jpg](/images/s3-bucket.jpg)
- **T.I.Q.S. Armageddon Repo:**
  - [**Full README.md**](/images/armageddon.md)
