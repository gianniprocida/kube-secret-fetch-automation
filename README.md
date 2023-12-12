## Project Overview ##

We create a pod and authorizing it to access secrets from the Kafka namespace 
(where the axual platform lives). The process involves generating a directory structure 
under 'mycertificates' for each component and storing the secret data in files within 
their respective directories. Please note, this is solely for educational purposes to explore the functionality of the 
Kubernetes library in Python.

## How to run it ##

Follow these steps:


## Build the docker image



You could push the image to your Docker Hub or use the field imagePullPolicy: Never (image 
already present locally).


# Create a role resource named 'pod-listing-role' with specific permission

kubectl create role pod-listing-role \
  --verb=get,list \
  --resource=pods,secrets \
  --namespace=kafka \
  --dry-run=client -o yaml > my-role.yaml


## Create a rolebinding resource that binds the pod-listing-role to the default ServiceAccount

kubectl create rolebinding pod-listing-binding \
  --role=pod-listing-role \
  --serviceaccount=kafka:default \
  --dry-run=client \
  --namespace=kafka \
  -o yaml > my-role-binding.yaml


## Create a pod using the image giprocida/axual-debug:1.0 

kubectl run debug-pod \
  --image=giprocida/axual-debug:1.0 \
  --namespace=kafka \
  --dry-run=client -o yaml -- sleep 4000 > debug-pod.yaml

# Modify the pod configuration by adding

imagePullPolicy: Never 

within the 'containers' field

Apply all the newly created resources.


The previously described procedure is automated through the use of the scripts: create-resources.sh and run-debug.sh.

Run the script create-resource.sh to create all the necessary resources.
Run the script run-debug.sh to apply all the newly created resources.

