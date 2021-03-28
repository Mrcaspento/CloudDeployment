# Access roles for configuring IBM Cloud Container Registery

- To grant a user permission to configure your IBM Cloud Container Registry in your account, you must create a policy that grants one or more of the roles in the following table. When you create your policy, you must not specify a `resource type` or `resource`. Policies for configuring IBM Cloud Container Registry must not be set at a resource group level.

- For example, run the following ibmcloud iam user-policy-create command. Where `<user_email>` is the user's email address, <region> is the region, and `<roles>` is the role, or roles, that you want the user to have.