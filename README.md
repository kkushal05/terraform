# terraform

The project contains 4 files:

k8s.tf is the terraform file to create the resources in jenkins namespace. All the uploaded files are tested and is in working condition.
jenkins.yaml - Contains the JCASC configuration to configure jenkins with Kubernetes cloud and jobs.
plugins.txt -  Contains few plugins that need to be installed

The jenkins is configured to load with username **admin** and pssword **admin** as credentials.
Running the job spawns a pod with 2 containers in the jenkins namespace. The 2 containers are namely for alpine and JNLP agent. The JNLP agent inside the pod communicates with the Jenkins server on port 50000, which is exposed as a service.

