# RedHatOpen

RedHatOpenShift is a hyrbid cloud, enterprise Kubernetes application platform,
Hybrid cloud: can be run on premises or in public and private clouds
Kubernetes: is an underlying technology
Application platform: provides additional tooling for applications

Kubernetes is a cruical component of OpenShift
In an OpenShift environment, the kubnetes control plane runs on Red hat Enterprise Linux CoreOS, while worker nodes support Red Hat Enterprise Linux

## Origin Kubernetes Distribbutation (OKD)

- Upstream Kubernetes distribution embedded in OpenShift
- Adds developer and operations-centric tooling ontop of Kubernetes
- Analogy: Kubernetes is the kernal, OpenShift is the distribution

### OpenShift

    - is build with kubernetes
    - native kubernetes capabilities are also present
    - both are open source
    - Open Shift is a product
    - Kubernetes is a project

OpenShift has its on CLI called "oc"
the oc CLI includes a copy of kubectl, so you can still run kubectl commands with oc

- also includes addition

- IN Kubernetes you need to use a dashboard, to find your use cases
  - ELK stack
    - intergration capabilities like Istio
  - Grifani
- APIs

## Builds

Automation Tool in RedHat OpenShift

- CI/CD
  - Cloud-native development calls for automation
  - Continuous intergration and continuous delivery is one example

In OpenShift a Build is the process pf transforming inputs into a resultant object

- the input could be source code in a git repository
  - while the result would be a container image
- A Build configuration, or BuildConfig, is an OpenShift-specfic object that defines
  - the process for a build to follow - the BuildConfig is the blueprint, and the Build is an instance of that blueprint put into action
    OpenShift builds can automate the build process that we preformed in our earlier modules
- Given a repository that contains a Dockerfile and necessary artifacts,

  - OpenShift invokes the `docker build` command to create an image
    when the build is started, OpenShift will take the input and produce a resultant image
    - Pushing it to the internal OpenShift registry
  - this strategy is called `Docker`
  - `Source-to-Image` is another build strategy offered by Open-Shift
    - `s2i` abbreviated is a tool for building reproducible container images.
      S2i injects app source code into a container image to produce a ready-to-run image
      The new image is built by incorporating a builder image and source to image in a single step

### Custom Builds

- more advanced strategy
- First you must define a builder image that will be used for the build process, rather that relying on a builder image provided by OpenShift.
- Custom builder images are Docker images that contain the logic needed transform inputs into the expected output
  BuildConfig:
  > - Output: what the build will produce
  > - Strategy: Which build strategy the Build will use
  > - Source: inputs to the build

## BuildTriggers:

- `Webhook`: Send a request to an OpenShift Container Platform API endpoint
  - often is a Github webhook and generic webhooks
  - when github is utilized, Github can send the request to OpenShift when there is a new commit on a certain branch.
- `ImageChange`: can be triggered when a new version of an image is available
  - if your app is built with Node.js base image that image will be updated as security fixes are released and other updates occur
  - useful for keeping base images up to date
- `Configuration change`
  - Build when a new BuildConfig is created resource is created

## ImageStream

- Abstraction for refrencing images within OpenShift
- Do not contain image data, but are merely pointers
- Source images can be stored in OpenShift's internal registry, external registry, or other ImageStreams:
  > Let’s say you store your images in IBM Cloud Container Registry, and you push an image
  > to your repo using the tag “latest.”
  > You can push another image to that repo and use the ”latest” tag again, which will
  > remove it from your first image.
  > If your Deployments were referring to images by repo and tag, they would now start pulling
  > the new image, but that could be unintended.
  > Each image also contains an ID, or digest, that identifies it.
  > While tags can change the digest will not
  > ImageStreams don not contain image data but are pointers to image digests
  > So even if a new image is pushed with the sametag, Deployments refrencing the ImageStream will not be changed until the Image Stream is updated to the point to the new image
  > The source images that ImageStreams point to can be stored in the internal registry, external registries, or other Images Streams

## Operators

- Are powerful pattern used within Kubernetes to automate tasks within a cluster, and Red Haat OpenSHift provides a great way to easily install and use them
- an operator is a way to package, deploy, and manage a kubernetes native application.
- Human operators know how to deploy and mange serivces
- Software operators capture and automate this logic
- thus operators are a way to package whole apps or automate other tasks
  - additional resources can be created to extend Kubernetes API called:

### in practice

- create a custom resource for the application
- Deploy a controller for this CRD
- Operator logic determines how to reconcile the actual and desired states
  - Objects that would need to be created: > Deployments, PVC(storage), Services, etc
    IN the ` OpenShift Container Platform web console`, there is a view called ` OperatorHub`
    - this view makes it so that to the user a lot of host operators that can be installed
      - `RedHat Operators` which are products packaged and shipped by RedHat
      - `Certified Operators` from inpendent software vendors that Red Hat has partnered with.

### Custom Resource Definitions (CRDs)

`CRD`

- extensions of the Kubernetes API
- Make the Kubernetes API modular and flexible
- Ultimately a custom resource is simply a new endpoint in the Kubernetes API that stores a collection of API objects
  - CRDs can be installed in clusters as operators choose.
  - Can be installed in clusters
  - Once installed, its objects can be accessed normally using kubectl as you would for Pods
  - they let you store and retrive data, but don't change the actual state of the cluster

To change the state, you need a :
`Custom contoller`

- note: controllers are control loops that run in kubernetes and monitor the actual state of the cluster
- Custom Controllers interpret the custom resource data stored in in the APi as a desired state
  - as with all controllers, work to maintain that state

Combining custom resources and custom controllers gives a true delcarative API like Pods possess

- This is knowen as the `Operator pattern`
