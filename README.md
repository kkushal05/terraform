# terraform

 All configuration needs to be done with Terraform.\n
• The deployment needs to be fully automated. - **Done**
• Orchestrated by Kubernetes, the workers need to be dynamically created on- demand. - **Done**
• Make a private git repository and share it with us when ready.  - **Done**
• Make a README.md that provides instructions, explains your choices and references the
sources you used. - **Done**
• Include what are some other things that you would recommend to add to this project in the
README.md - **Done**


The project contains 4 files:

k8s.tf is the terraform file to create the resources in jenkins namespace. All the uploaded files are tested and is in working condition.
jenkins.yaml - Contains the JCASC configuration to configure jenkins with Kubernetes cloud and jobs.
plugins.txt -  Contains few plugins that need to be installed

The jenkins is configured to load with username **admin** and pssword **admin** as credentials.
Running the job spawns a pod with 2 containers in the jenkins namespace. The 2 containers are namely for alpine and JNLP agent. The JNLP agent inside the pod communicates with the Jenkins server on port 50000, which is exposed as a service.

Recommendations:

1. Since the containers can come up on any node, we should utilize the full capacity of th cluster.
2. Use seedjobs instead of fixed jobdsl scripts in the JCASC jenkins.yaml file. Using seed jobs to configure jenkins helps us to dynamically update/configure the job in github. Also, it is version controlled, so changes are tracked.
3. Using a PVC for jenkins. I have used and tested a PVC also with terraform, but this is not added here. If you need it, let me know.
4. Using variables in terraform templates. Instead of hardcoding important field names, values, we can leverage the feature of using variables.tf files with the main terraform template.
