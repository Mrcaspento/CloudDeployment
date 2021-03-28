# Creating an Image

1. Tag an image to point to this registry. Choose a local image, target namespace, and target repository and an optional tag.

- `docker tag <local_image> us.icr.io/<My_NameSpace>/<My_Repo>:<My_Tag>`

2. Push the tagged image

- `docker push us.icr.io/<My_NameSpace>/<My_Repo>:<My_Tag>`
