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



# **Automating HPC Deployments on Google Cloud with Cloud Build 🚀**

This tutorial guides you through setting up a continuous integration (CI) pipeline using **Google Cloud Build** to automatically deploy high-performance computing (HPC) environments. We'll use the **Google Cloud HPC Toolkit** (`ghpc`) to define the infrastructure in YAML files.

By the end of this tutorial, you'll be able to push changes to your Git repository and have Cloud Build automatically deploy or update your HPC cluster.


---


## **Prerequisites**

Before you begin, make sure you have the following:



* A **Google Cloud Project** with an active billing account.
* The **<code>gcloud</code> command-line tool** installed and authenticated (`gcloud auth login`).
* A **Git repository** (e.g., on GitHub, GitLab, or Cloud Source Repositories) containing your HPC Toolkit configuration files.
* The required APIs enabled in your project. You can enable them with this command: \
Bash
* 


---


## **Step 1: Prepare Your Repository 📁**

Your Git repository needs to contain your HPC deployment and blueprint files, along with the `cloudbuild.yaml` file we will create.

Your repository structure should look like this. The key is that `cloudbuild.yaml` is at the root, and the paths to your deployment files inside the YAML are correct relative to the root.

**Note:** You do not need to include the `ghpc` binary in your repository. We will use the official Google-managed container image, which has all dependencies pre-installed.


---


## **Step 2: Create the <code>cloudbuild.yaml</code> File 🛠️**

This file tells Cloud Build what to do. Create a file named `cloudbuild.yaml` in the root of your repository with the following content. This configuration uses the official HPC Toolkit container image, which is the recommended method.

YAML


---


## **Step 3: Grant Permissions to Cloud Build 🔑**

Cloud Build runs using a special service account. You must give this account permission to create the resources for your HPC cluster (like VMs, networks, IAM roles, etc.).



1. First, identify your Cloud Build service account. Run the following commands to store its email address in a shell variable: \
Bash
2. 
3. Next, grant the necessary IAM roles to this service account. The HPC Toolkit needs broad permissions to manage infrastructure. \
Bash
4. 

    **Security Note**: For production, always follow the principle of least privilege. You can analyze the specific resources in your blueprint to grant more granular roles instead of broad ones like `compute.admin`.



---


## **Step 4: Create a Cloud Build Trigger ⚙️**

A trigger automatically starts a build in response to repository events, like a `git push`.



1. In the Google Cloud Console, navigate to the **Cloud Build** > **Triggers** page.
2. Click **Connect repository** and select your source code provider (e.g., GitHub). Follow the authentication steps.
3. Once connected, click **Create trigger**.
4. Fill out the trigger settings:
    * **Name**: A descriptive name, like `deploy-hpc-cluster-main`.
    * **Event**: Select **Push to a branch**.
    * **Source**: Select your repository and the branch that will trigger builds (e.g., `main`).
    * **Configuration**: Choose **Cloud Build configuration file (yaml or json)**. The location should default to `/cloudbuild.yaml`.
5. Click **Create**.


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
