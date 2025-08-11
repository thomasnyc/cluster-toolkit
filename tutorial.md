<!-----



Conversion time: 0.906 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β44
* Fri Aug 08 2025 13:06:10 GMT-0700 (PDT)
* Source doc: Untitled document
----->



# **Automating HPC Deployments on Google Cloud using Cluster Toolkit**

This tutorial guides you through setting up a continuous integration (CI) pipeline using **GCP Cluster Toolkit** to automatically deploy high-performance computing (HPC) environments. We'll use the **Google Cloud HPC Toolkit** (`gcluster`) to define the infrastructure in YAML files.

In order to kick off the demo / tutorial, please click on the link:
https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/thomasny
c/cluster-toolkit&cloudshell_tutorial=tutorial.md


By the end of this tutorial, you'll be able to push changes to your Git repository and have Cloud Build automatically deploy or update your HPC cluster.


---


## **Prerequisites**

Before you begin, make sure you have the following:


* A **Google Cloud Project** with an active billing account.
* The **<code>gcloud</code> command-line tool** installed and authenticated (`gcloud auth login`) & (`gcloud auth application-default login`) follow the command below: 
* A **Git repository** (e.g., on GitHub, GitLab, or Cloud Source Repositories) containing your Cluster Toolkit configuration files. Cloud shell command shall already clone the repository required.

* Run the gcloud auth login and gcloud auth application-default login 
```bash
gcloud auth login
```

```bash
  gcloud auth application-default login
  export GOOGLE_APPLICATION_CREDENTIALS=
```
Note: 
Credentials saved to file: [/tmp/xxxxx/application_default_credentials.json]
Then copy the full path to export GOOGLE_APPLICATION_CREDENTIALS=xxx.json


* Set the default GCP project:

```bash
  gcloud config set project 
```

* You can install the terraform , go, packer with this script:
```bash
chmod 755 cloudshell-install-dependence.sh 
sudo ./cloudshell-install-dependence.sh 
```
* Then we need to run **make** command to build the **ghpc and gcluster** command.

```bash
make
```
---


## **Step 1: Prepare the clsuter variables and blueprint file 📁**

Your Git repository needs to contain your HPC deployment and blueprint files

1. Update the deployment file
Using a text editor, open the examples/machine-learning/a3-megagpu-8g/a3mega-slurm-deployment.yaml file.

In the deployment file, specify the Cloud Storage bucket, set names for your network and subnetwork, and set deployment variables such as project ID, region, and zone.

```yaml
terraform_backend_defaults:
  type: gcs
  configuration:
    bucket: <user-terraform-bucketname>

vars:
  deployment_name: a3mega-lustre-base
  project_id: <user-GCP-project-ID>
  region: <region>
  zone: <zone>
  network_name_system: a3mega-sys-net
  subnetwork_name_system: a3mega-sys-subnet
  enable_ops_agent: true
  enable_nvidia_dcgm: true
  enable_nvidia_persistenced: true
  disk_size_gb: 200
  final_image_family: slurm-a3mega
  slurm_cluster_name: a3mega
  a3mega_reservation_name: "" # supply reservation name
  a3mega_maintenance_interval: ""
  a3mega_cluster_size: 2 # supply cluster size
```
Replace the following:

* BUCKET_NAME: the name of your Cloud Storage bucket, created in the previous section.
* PROJECT_ID: your project ID.
* REGION: a region that has a3-megagpu-8g machine types.
* ZONE: a zone that has a3-megagpu-8g machine types.
* NETWORK_NAME: a name for your network. For example, a3mega-sys-net.
* SUBNETWORK_NAME: a name for your subnetwork. For example, a3mega-sys-subnet.
* RESERVATION_NAME: the name of your reservation provided by your Google Cloud account team when you requested capacity.
* MAINTENANCE_INTERVAL: specify one of the following:
  If you are using a reservation created by your account team, set a3mega_maintenance_interval: PERIODIC
  If you created your own reservation, set a3mega_maintenance_interval: "". This action sets the maintenance value to an empty string which is the default value.
* NUMBER_OF_VMS: the number of VMs needed for the cluster.

---


## **Step 2: Update the blueprint file 🛠️**

Cluster Toolkit provisions the cluster based on the deployment file you created in the previous step and the default cluster blueprint.
We offered the sample example/machine-learning/a3-megagpu-8g/**a3mega-slurm-blueprint.yaml**

Our team has the **a3mega-lustre-slurm-blueprint.yaml** sample which includes managed-lustre creation service.
Please make any upates needed. 

---


## **Step 3: Deploy the Cluster 🎉**

Option 1 - This is the single click deployment: 
If you never create the network and the image, please run this option:

```bash
./gcluster deploy -d examples/machine-learning/a3-megagpu-8g/a3mega-slurm-deployment.yaml examples/machine-learning/a3-megagpu-8g/a3mega-lustre-slurm-blueprint.yaml --auto-approve
```


Option 2 - Deploy / Destroy the cluster only 
If you want to Deploy / Destroy the clsuter only. Please follow the following steps: 

Deploy the cluster only: 

```bash
test command here: 
```

Delele the clsuter only:

```bash
test commmand here: 
```

---

## **Cleaning Up 🧹**

HPC clusters can be expensive, so it's critical to tear down your resources when you are finished.

You can destroy the deployment by running the `ghpc destroy` command locally with the same deployment file.

```bash
./gcluster destroy a3mega-lustre-base/
```