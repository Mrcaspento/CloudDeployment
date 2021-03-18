1. install google cloud SDK CLI
2. Configure the SDK with out Google Cloud auth info
3. Login to Docker CLI
4. Build the 'test version of "multi-client"'
5. run tests
6. If tests are successful, run a script to deploy newest images
7. Build all our images, tag each one, push each to docker hub
8. Apply all configs in the "k8s" folder `kubectl apply -f k8s`
9. Imperatively set latest images on each deployment
10. create a service account
11. download service account credintials in a json file
12. Download and install travis cli
13. Encrypt and upload the json file to our travis account
14. in travis.yml add code to unencrypt the json file and load it into GCloud SDK

---

# Creating a IAM service account

1. Click the Hamburger menu on the top left-hand side of the dashboard, find IAM & Admin, and select Service Accounts. Then click the CREATE SERVICE ACCOUNT button.

2. In the form that is displayed, set the Service account name to travis-deployer (step 1), then click the CREATE button (step 2).

3. Click in the Select a role filter and scroll down to select Kubernetes Engine and then Kubernetes Engine Admin.

4. Make sure the filter now shows Kubernetes Engine Admin and then click CONTINUE

5. The Grant users access form is optional and should be skipped. Click the DONE button.

6. You should now see a table listing all of the service accounts including the one that was just created. Click the three dots to the right of the service account you just created. Then select Manage Keys in the dropdown.

7. In the Keys dashboard, click ADD KEY and then select Create new key.

8. In the Create private key dialog box, make sure Key type is set to JSON, and then click the CREATE button.

9. The JSON key file should now download to your computer.

---

# Work around without installing Ruby localyand installing teh Travis-cli to enycrpt a json file!

1. Run `docker run -it -v $(pwd):/app ruby:2.4 sh`
2. after docker pulls the image run `gem install travis`
3. run `travis login --github-token <YOUR_Personal_Token> --com`
4. after loggin in you must pass the same --com or --pro flag you used to login
5. we
6. run `travis encrypt-file service-account.json -r username/repo --com`
7. delete the service-account.json file after you encrypt it
