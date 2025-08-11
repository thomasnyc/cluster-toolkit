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

By the end of this tutorial, you'll be able to push changes to your Git repository and have Cloud Build automatically deploy or update your HPC cluster.


---


## **Prerequisites**

Before you begin, make sure you have the following:


* A **Google Cloud Project** with an active billing account.
* The **<code>gcloud</code> command-line tool** installed and authenticated (`gcloud auth login`).
* A **Git repository** (e.g., on GitHub, GitLab, or Cloud Source Repositories) containing your HPC Toolkit configuration files.
* The required APIs enabled in your project. You can enable them with this command: \
```bash
sudo ./cloudshell-install-dependence.sh 
```
* 
---


## **Step 1: Prepare the clsuter variables and blueprint file 📁**

Your Git repository needs to contain your HPC deployment and blueprint files

1. Update the deployment file
Using a text editor, open the examples/machine-learning/a3-megagpu-8g/a3mega-slurm-deployment.yaml file.

In the deployment file, specify the Cloud Storage bucket, set names for your network and subnetwork, and set deployment variables such as project ID, region, and zone.

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

---


## **Step 2: Update the blueprint file 🛠️**

Cluster Toolkit provisions the cluster based on the deployment file you created in the previous step and the default cluster blueprint.
We offered the sample **a3mega-slurm-blueprint.yaml**

Our team has the **lustre-nvidia-jul28-a3mega-slurm-blueprint.yaml** sample which includes lustre creation service.
Please make any upates needed. 

---


## **Step 3: Deploy the Cluster 🔑**

Option 1 - This is the single click deployment: 

```bash
sh ./gcluster deploy -d examples/machine-learning/a3-megagpu-8g/a3mega-slurm-deployment.yaml examples/machine-learning/a3-megagpu-8g/lustre-nvidia-jul28-a3mega-slurm-blueprint.yaml --auto-approve
```


Option 2 - if one already deployed the cluster before. 

Delele the clsuter only:




Deploy the cluster only: 




    **Security Note**: For production, always follow the principle of least privilege. You can analyze the specific resources in your blueprint to grant more granular roles instead of broad ones like `compute.admin`.



---



## **Step 5: Run Your Deployment! 🎉**

Your automated pipeline is now active! To run the deployment, simply commit and push your files to the branch you configured in the trigger.

Bash

You can watch the build's progress in real-time in the **Cloud Build** > **History** page in the Google Cloud Console.


---


## **Cleaning Up 🧹**

HPC clusters can be expensive, so it's critical to tear down your resources when you are finished.

You can destroy the deployment by running the `ghpc destroy` command locally with the same deployment file.

Bash

Remember to also **disable or delete the Cloud Build trigger** in the console to prevent any future accidental builds.
