# OpsSchool Final Project

<div id="top"></div>

:elephant: [Related Repository - Kandula App][kandula-app]

<br />
<div align="center">
  <a href="https://github.com/yossima066/kandula-final-project-opsschool.git">

![Dumbo](/d4c22a8b5f806a7a4cf3742ae6d3639e.gif)

<h3 align="center">OpsSchool Final Project</h3>

  <p align="center">
    <a href="https://github.com/yossima066/kandula-final-project-opsschool.git"><strong>Explore the files »</strong></a>
    <br />
    <br />
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
      </ul>
    </li>
    <li>
      <a href="#prerequisites">Prerequisites</a>
      <ul>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a></li>
      <ul>
      </ul>
    </li>
    <li>
      <a href="#variables">Variables</a>
      <ul>
      </ul>
    </li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

Infrastructure Architecture Diagram

![Inf](/PNG/2.png)

Application and CI/CD flow diagram

![App](/PNG/1.png)

A small production environment for a highly available web application <a href="https://learn.hashicorp.com/tutorials/terraform/install-cli">(Kandula)</a> on AWS.

<p align="right">(<a href="#top">back to top</a>)</p>

---

<!-- Prerequisites -->

## Prerequisites

In order to set the environment you will need a linux machine with the following installed:

- <a href="https://learn.hashicorp.com/tutorials/terraform/install-cli">Teraform cli</a>
- <a href="https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html">AWS cli</a>
- <a href="https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/">kubectl</a>
- <a href="https://helm.sh/docs/intro/install/">Helm</a>
- <a href="https://docs.npmjs.com/downloading-and-installing-node-js-and-npm">npm</a> (optional)
- <a href="https://docs.snyk.io/snyk-cli/install-the-snyk-cli">snyk</a> (optional)

<p align="right">(<a href="#top">back to top</a>)</p>

---

<!-- USAGE EXAMPLES -->

## Usage

1. Clone the repository to your mechine:
   <br />
   ```
   git clone https://github.com/yossima066/kandula-final-project-opsschool.git
   ```
2. Set your AWS credentials as environment vars:
   <br />
   ```
   export AWS_ACCESS_KEY_ID=EXAMPLEACCESSKEY
   export AWS_SECRET_ACCESS_KEY=EXAMPLESECRETKEY
   export AWS_DEFAULT_REGION=us-east-1
   ```
3. Use the example.tfvars file and enter the username and password that you wish to set for the RDS instance:
   <br />
   ```
   # AWS
   db_username             = "example"
   db_password             = "example12345"
   ```
4. Optional: scan terraform's configuration files
   for vulnerabilities with <a href="https://docs.snyk.io/snyk-cli/install-the-snyk-cli">snyk</a>:
   <br />
   ```
   cd /OpssSchool-Final-Project
   snyk auth
   snyk iac test .
   ```
5. Optional: scan terraform's plan for vulnerabilities with <a href="https://docs.snyk.io/snyk-cli/install-the-snyk-cli">snyk</a>:
   <br />

   ```

   terraform init
   terraform plan -out=tfplan.binary
   terraform show -json tfplan.binary > tf-plan.json
   snyk iac test --scan=planned-values tf-plan.json
   ```

   > **📝 Please Note:**
   > The default name of the S3 bucket is set on the variables.tf file as `"terraformstate-environments/Development/"` and the region as `us-east-1`, you can change the name of your choice, just note that the name must be unique.<br />
   > Terraform's state for the S3 bucket will be saved locally on youre station.
   > <br />

6. Create the infrastructure of the environemnt:
   <br />

   ```
   terraform plan
   terraform apply -auto-approve
   ```

   > **📝 Please Note:**
   > If you changed the name of the S3 bucket , you will need to change it also on the variables.tf file on this dir.<br />

   See further details regarding the variables of the project below.
   <br />

   For your convenience terraform will output the follwing values:
   <br />
   | Resource | Value |
   |--------------------------|-----------------|
   |Bastion server | Public IP |
   |Application Load Balancer | Public DNS Name |
   |Consul UI | URL Link |
   |Jenkins UI | URL Link |
   |Prometherus UI | URL Link |
   |Grafana UI | URL Link |
   |Kibana UI | URL Link |
   |EKS cluster | Cluster Name |
   <br />

7. Set up Jenkins server - access the Jenkins UI and add the following credentials:
   <br />
   | ID | Value | Description |
   |--------------------|--------------------|-------------|
   | Jenkins Agents | username + ssh key | The jenkins agents\ nodes credentials for the use with jenkins server|
   | Github | username + ssh key | The Github credentials in order to use the private repository |
   | Dockerhub | username + password| The Docker hub credentials in order to upload Kandula's image to Dockerhub's registry|
   | Slack | token | Slack token in order to set Slack notifications|
   | Postgres DB | username + password| The username and password for accessing the Postgres DB|
   <br />
8. Kandula's App:
   Clone the repository
   <br />
   ```
   git clone https://github.com/yossima066/kandula-project-app.git
   ```
9. Deploy Kandula to K8s:
   deploy-kandula-k8s: Docker build & push to DockerHub, apply a K8s Deployment, Service & HPA,
   then Kubernetes script:

   - create secret
   - apply dnsutils
   - Helm install Consul from values.yaml
   - Helm install kube-prometheus
   - Filebeat

   <br />

10. Clean up and destroy the environment:
    ```
    kubectl delete service kandula-project-lb
    kubectl delete deploy kandula-final-project-deployment
    terraform destroy -auto-approve -var-file=<file_name>.tfvars
    ```

<p align="right">(<a href="#top">back to top</a>)</p>

---

<!-- VARIABLES -->

### Variables

The main input variables (can be changed as of your choice):
| Name | Description | Type | Default value |
|-------------------------|-------------------------------------------------|------|-----------------------------------------------------------------------------|
|aws_region | AWS region in which to deploy the infrastructure|string| us-east-1 |
|vpc_cidr | VPC cidr block |string| 10.0.0.0\16 |
|number_of_public_subnets | Number of public subnets to create |number| 2 |
|number_of_private_subnets| Number of private subnets to create |number| 2 |
|key_name | Name of the pem key for the instances |string|Homwork |
|route53_domain_name | Internal domain name for route53 hosted zone |string|kandula.opsSchool |
|default_tags | Tags for the created reasources |string|evironment=prod, owner_tag=opsschool-yossi, project_tag= final-project |
|alb_name | Application Load Balancer name |string|private-resources-alb |
|instance_type | EC2 instance type |string|mainly t2-micro , t3-large. |
|number_of_instances | Number of instances for every kind of server |number|consul=3, jenkins-agents=2, rest=1, ELK=1, EKS=1 |  
|instance_name | Name of the instance on aws and on consul's DNS |string|different values |
|cluster_name | Name of the EKS cluster |string|project-eks |

<!-- MARKDOWN LINKS & IMAGES -->

[kandula-app]: https://github.com/yossima066/kandula-project-app.git
