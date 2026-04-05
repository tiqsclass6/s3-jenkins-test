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

## Snyk Demos (CLI, Jenkins Plugin, and Web UI)

- <https://github.com/user-attachments/assets/b10c02ef-9c2e-4bfa-8745-e76f5a348245>
- <https://github.com/user-attachments/assets/ac43752a-532e-49f8-972c-7e439ef28b12>

- [**Snyk Report (U/I): `s3.tf (errors)`**](https://app.snyk.io/org/daquietstorm22/project/e8af82ef-22aa-4963-9c62-7829558f4b12/history/5d6355bd-fdf9-4a9e-8d12-0dd861a86e51)

---

## Artifacts

- **T.I.Q.S. Armageddon Repo:**
  - [**Full README.md**](/images/armageddon.md)
- **Jenkins Pipeline Output**
  ![jenkins-pipeline.jpg](/images/jenkins-pipeline.jpg)
- **Jenkins Webhook Output**
  ![jenkins-webhook.jpg](/images/jenkins-webhook.jpg)
- **S3 Bucket Output**
  ![s3-bucket.jpg](/images/s3-bucket.jpg)
- **Snyk CLI Output**
  ![snyk-monitoring-pt1.jpg](/images/snyk-monitoring-pt1.jpg)
- **Snyk Jenkins Plugin Output**
  ![snyk-monitoring-pt2.jpg](/images/snyk-monitoring-pt2.jpg)
  ![snyk-monitoring-pt3.jpg](/images/snyk-monitoring-pt3.jpg)
- **Snyk Report (U/I) Output**
  ![snyk-report-ui.jpg](/images/snyk-report-ui.jpg)
- **Suge WAF Output**
  - ![suge-waf.jpg](/images/suge-waf.jpg)

---

## Author

- **Team Lead:** John Sweeney
- **Author:** T.I.Q.S. DevSecOps
  - [**GitHub Home**](https://github.com/tiqsclass6)