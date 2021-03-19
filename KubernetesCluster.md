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

---

## Step 3 Configure DevOps delivery pipeline

1. click Deploy your app, under the Configure Continuous Delivery tile.
2. Select Kubernetes Service as the Deployment target
3. Provide an IBM Cloud API Key. If you don't have one, create by clicking on New
4. Select a region and your cluster from the list
5. Select Helm as the Deployment type and click on Next
6. Define a unique DevOps toolchain name.
7. Select a region to create you toolchain in
8. click Create

- The toolchain will build your application and deploy it to the cluster
  1. Once the pipline is created, click the pipeline under Delivery Pipelines
  2. After the Deploy stage passes, click on View logs and history to see the logs
  3. Visit the URl desplayed to access the application `http://worker-public-ip:portnumber/`

---

## Step 4 Modify the application and deploy the updates

1. Follow the breadcrumbs on the upper left of the screen and click on the first entry after of `<your-initial>-mynodestarter` after Toolchains
2. Click the Eclipse Orion Web IDE tile.
3. Expand the `<yourInitials>-mynodestarter` and then public.
4. Update the index.html by making a simple change, for example change "Congratulations!" to something else, your changes are automatically saved.
5. Click on the Git icon in the left most column.
6. Enter a commit message: my first changes and click on Commit.
7. On the left in the Outgoing section click Push.
8. Click on the arrow at the top to get back to the toolchain.
9. Click on the Delivery Pipeline tile.
10. Notice a new BUILD has started.
11. Wait for the DEPLOY stage to complete.
12. After the DEPLOY stage passes, click on View logs and history to see the logs and open the application.

---

## Step 5 Deploy to a production envionment

1. Go to the toolchain you create earlier and click the Delivery Pipeline tile
2. Rename the DEPLOY stage to `Deploy dev` by clicking on the settings icon, then Coonfigure Stage.
3. To save the changes scroll down and click Save
4. Clone the Deploy dev stage ( settings icon > Clone Stage) and name the cloud stage as `Deploy prod`
5. On the Input panel change the stage trigger to Run jobs only when this stage is run manually.
6. In Environment properties panel, set CLUSTER_NAMESPACE to production.
7. Save the stage.
8. Click the Play button on the Deploy prod stage just created.
   - You now have the full deployment setup. To deploy from dev to production, you must manually run the Deploy prod stage. This is a simplification process stage over a more advanced scenario where you would include unit tests and integration tests as part of the pipeline.

## Step 6 Setup Slack notifications

1. Go back to view the list of toolchains and select your toolchain, then click on Add a Tool.
2. Search for Slack in the search box or scroll down to see Slack. Click to see the configuration page.
3. For Slack webhook, follow the steps in the link. You need to login with your Slack credintials and provide an existing channel name or create a new one
4. Once the Incoming webhook integration is added, copy the Webhook URL and paste the same under Slack webhook
5. The Slack channel is the channel name you provided while creating a webhook intergration above.
6. Slack team name is the team-name( first part) of the team-name.slack.com e.g.. kube is the team name in the kube.slack.com
7. Click Create Intergration. A new tile will be added to you toolchain
