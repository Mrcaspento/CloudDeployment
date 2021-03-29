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
  > Output: what the build will produce
  > Strategy: Which build strategy the Build will use
  > Source: inputs to the build
