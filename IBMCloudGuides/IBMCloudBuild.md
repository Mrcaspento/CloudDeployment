# First step

- Get the client, server, and worker folders ready from a previous repo

# Setting Up the IbmCloud & having it autoGen a application

1. first make sure you are signed up on IBM with an account
2. follow this link to make sure you have the ibm cli [click here](https://cloud.ibm.com/docs/cli?topic=cli-getting-started#step1-install-idt)
3. once installed login inside yout terminal with `ibmcloud login`
4. Then make sure you target a resource group, whcih is usually `Default` or `default`(case-sensitive)
   - `imbcloud target -g Default`
     or
   - `ibmcloud target -g default`
5. you can use a kubernetes starter kit running the command `ibmcloud dev create` into a directory of your choice just follow the prompts
   - Select Backend Service / Web App > Node> Node.js Express App.
   - Enter a unique name for your application such as <your-initials>kubeapp.
   - Select the resource group where your cluster has been created. This might happen automatically.
   - Do not add additional services.
   - Do not add a DevOps toolchain, select manual deployment.
   - Choose "Deploy to Helm-based Kubernetes containers"
6. after operations are complete, manually merge the deployment and cloud enablement files that are saved to the app directory
   follow the next couple of steps or SKIP TO STEP**\*\*\*\***\*\***\*\*\*\***\*\***\*\*\*\***\*\***\*\*\*\***
7. check if the app has been stored in the directory with `ls`
8. Change into the directory
9. run the command `ibmcloud dev build`
10. then run the command `ibmcloud dev run`
11. Check to see that is running by going to `localhost:3000` you should see something like this
    ![deployed](./images/IBM_Cloud_deployed.PNG)

## Adding a serivice and modyfying the code

1. run `ibmcloud dev edit` command in the cli
2. follow the prompts to create and connect a new data-related service to you app, such as IBM Cloudant
3. you can manually merge the configuration files that are saved to you appdirectory when you creat the service. Or you can skip this step for now.
4. Update your code
5. save any files that you modified

- Enabling command parameters

  - config file `imbcloud dev enable --config-file <configFileName>`
    - specify a `cli-config.yaml` file to use for a command
  - force `ibmcloud dev enable -f|--force`
    - parameter that is used to force a reenabling an already enabled app
  - language `ibmcloud dev enable -l|--language <language>`
    - parameter that is used to specify the langugage of the app to be enabled
  - trace `ibmcloud dev enable --trace`
    - use this parameter to provide vebose output
  - get-credintials `ibmcloud dev get-credentails --trace`
    - use this parameter to provide verbose output

- ## List all IBM Cloud apps in a resource group
  - run the following comand `ibmcloud dev lists`

---

# Create a starter app

1. `ibmcloud login`
2. then, make sure you target a resource group, which is usually `Default` or `default`
3. `ibmcloud target -g default`
4. `'ibmcloud dev create`

## Configure access to you kubernetes cluster

1. Run the following command. It will download the configuration from IBM Cloud and also set the context for cluster: ##KUBE.id## to the kubeconfig file. This will make your kubectl client point to your Kubernetes cluster.

- `ibmcloud ks cluster config --cluster <KUBE.id>`
  - Your <Kube.id> should be next to your account name in ()

2. To list the clusters you have access to, run

- `ibmcloud ks cluster ls`

3. To list the resource groups that you have access to, run

- `ibmcloud resource groups`

4. To target the resource the resource groups that you have access to, run

- `ibmcloud resource groups`

5. To target the resource group, run

- `ibmcloud target -g <resource_group>`

# Build the application with IBMCloud

1. Ensure your local Docker engine is started

- `docker ps`

2. Define an environment variable name set with the name of the application you generated in the previous section:

- `export <variableName>=<AppYouGeneratedInPreviousStep>`

3. Change to the directory of the generated project

- `cd <variableName> && ls`

4. Build the application.

- `ibmcloud dev build --use-root-user-tools`

5. Run the application

- `ibmcloud dev run`
  - Test it by opening another terminal and type `curl localhost:3000`

6. Use `Ctrl+C` to end the execution and stop the app

## Push the container Image to Registry

1. Create an account on Docker Hub. Your Docker Id will become your public Reg namespace.
2. Run the following to set your namespace:

- `export MYNAMESPACE=<REGISTRY_NAMESPACE>`

3. Build and tag the docker image by running the following command:

- `docker build . -t ${MYNAMESPACE}/${MYPROJECT}:v1`

4. Login to docker on the cli

- `docker login`

5. Push the docker image to the public registery on Docker Hub witht eh following

- `docker push ${MYNAMESPACE}/${MYPROJECT}:v1`

## Deploy the app with Helm

1. Change to the chart directory:

- `cd chart/$MYPROJECT`
  - Helm uses the local "chart" files and creates the corresponding Kubernetes resources for you, such as the deployments and pods.

2. Install the chart:

- `helm install ${MYPROJECT} . --set image.repository=${MYNAMESPACE}/${MYPROJECT}`

## View the application

1. List the Kubernetes services in the namespace:

- kubctl get services

2. Locate the service linked to your application. It is named after your project. If your project name contains hyphens, they may have been removed by the chart, e.g my-project would become myproject.

3. Make note of the the public port the service is listening on. The port is a 5-digit number(e.g., 31569) under PORT(S).

4. Log back in to your ibmcloud account on the cli

- `ibmcloud login`

5. Identify a public IP of a worker node with the comman below:

- ` ibmcloud ks workers --cluster ##KUBE.name##`

6. Access the application at `http://worker-ip-address:portnumber/
