# Google Cloud Creation

1. Click the Hamburger menu on the top left-hand side of the dashboard.

2. Click Kubernetes Engine

3. Click the ENABLE button to enable the Kubernetes API for this project.

4. After a few minutes of waiting, clicking the bell icon in the top right part of the menu should show a green checkmark for Enable services: container.googleapis.com

5. If you refresh the page it should show a screen to create your first cluster. If not, click the hamburger menu and select Kubernetes Engine and then Clusters.

6. A Create Cluster dialog will open and provide two choices. Standard and Autopilot. Click the CONFIGURE button within the Standard cluster option

7. A form similar to the one shown in the video will be presented. Set the Name to multi-cluster (step 1). Confirm that the Zone set is actually near your location (step 2). The Node Pool that is discussed in the video is now found in a separate dropdown on the left sidebar. Click the downward-facing arrow to view the settings. No changes are needed here (step 3). Finally, click the CREATE button at the bottom of the form (step 4).

8. After a few minutes, the cluster dashboard should load and your multi-cluster should have a green checkmark in the table.

---

# Google Cloud Clean Up

1. Click the project selector on the top left of the page

2. Click the 'gear' icon on the top right

3. Find your project in the list of projects that is presented, then click the three dots on the far right hand side

4. Click 'Delete'

5. Enter your project ID and click 'Shut Down'
