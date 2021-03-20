# Annotations

---

With Annotations, we can attach arbitrary non-identifying metadata to any objects, in a key-value format:

"annotations": {
"key1" : "value1",
"key2" : "value2"
}

Unlike Labels, annotations are not used to identify and select objects. Annotations can be used to:

Store build/release IDs, PR numbers, git branch, etc.
Phone/pager numbers of people responsible, or directory entries specifying where such information can be found.
Pointers to logging, monitoring, analytics, audit repositories, debugging tools, etc.
Ingress controller information.
Deployment state and revision information.
For example, while creating a Deployment, we can add a description as seen below:

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
name: webserver
annotations:
description: Deployment based PoC dates 2nd May'2019
....
```

Annotations are displayed while describing an object:

` kubectl describe deployment webserver`

```yml
Name: webserver
Namespace: default
CreationTimestamp: Fri, 02 Oct 2020 05:10:38 +0530
Labels: app=webserver
Annotations: deployment.kubernetes.io/revision=1
description=Deployment based PoC dates 2nd May'2019
```
