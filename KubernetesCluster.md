# Creating a Development Kubernetes cluster

---

## Step 1 Create development Kubernetes cluster

1. open kubernetes clusters or navigate to Kubernetes > Clusters from the left hamburger nav menu
2. create a cluster
3. Choose standard plan, Default kubernetes version, Classic infrastructuture
4. Choose desired resource group
5. Choose desired Geography, Availability and Metro
6. One, zone, one worker node per zone and the smallest flavor with 2cpus, 4 gb ram, and 1 worker nodes is sufficient
7. master service endpoint of Public endpoint only
8. Choose a cluster name that you can remember

---

## Step 2 Create a starter application

1. from the IBM cloud console , use the left side menu option and select App Development
2. click starter kits
3. Select the `Node.js Express App` tile, click on get Started and then `Create app` to create a Node.js starter application
4. Enter a unqiue name for the application such as `<Your_intials>-mynodestarter` and select a resource group. Then, click Create.

## Step 3
