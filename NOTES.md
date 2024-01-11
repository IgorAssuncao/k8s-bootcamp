### Api server
Is the main communication point, everything goes through this guy.
When e.g. a new pod is created, the api-server will save the information of 
the intention of a new pod in the etcd and tells the scheduler to create a new
pod. When it receives the response the api-server communicates with the kubelet.

### Scheduler
Is responsible to tell the api-server where things will run.

### Worker Nodes
The Kubelet communicates with the container engine.

### Deployments
Deployment is a type of a Controller

### Jobs
Job is a type of a Controller
