# Sample Node Application

### Steps to start the application

To initialize the application we need to install Node.js, and perform these below steps,

```script
$ npm install # To install the required packages

$ npm start # To start the application
```

This Node.js Web application can perform operations such as,

1. Performing Fibonacci for the number

   Example:

    ```script
   /fibonacci?value=15
    ```
    
 ### Step to create Dockerfile for this application.
 
   Dockerfile:

    FROM node:12                  // Image for node:12

    WORKDIR /usr/share/app        // Creating workdir

    COPY package*.json ./         // Copying package.json file to workdir ( ./app )
    
    RUN npm install               // Installing all the dependencies and packages 

    COPY . .                      // Copy files to ./app

    EXPOSE 8080                   // Exposing Conatainer to port 8080

    CMD ["node", "server.js"]     // Starting the application

After creating Dockerfile, build it - 
```script
$ docker build -t docker451001/nodejs-test . 
```
Once build is complete, push it to docker repo - 
```script
$ docker push docker451001/nodejs-test
```
Now, We are done with docker parts, Let's deploy it to kubernetes cluster -

   Deployment-service-hpa.yaml

```script
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-fibonacci
  labels:
    app: node-fibonacci
spec:
  replicas: 10
  selector:
    matchLabels:
      app: node-fibonacci
  template:
    metadata:
      labels:
        app: node-fibonacci
    spec:
      containers:
      - name: node-fibonacci
        image: docker451001/nodejs-test:latest
        ports:
        - containerPort: 8080

---
apiVersion: v1
kind: Service
metadata:
  name: node-fibonacci
spec:
  selector:
    app: node-fibonacci
  ports:
  - name: example-port
    protocol: TCP
    port: 3000
    targetPort: 8080
  type: LoadBalancer

---
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: node-fibonacci
spec:
  maxReplicas: 10
  minReplicas: 7
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: node-fibonacci
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  - type: Resource
    resource:
      name: memory
      target:
        type: AverageValue
        averageValue: 60Mi

```

This single file has following resource:

1) First part of this file which is Deloyment part will create nodejs-test application ( which is hosted in Docker451001/nodejs-test repository ) with 10 replicas.

2) Second part is Service part which will expose the pods to port 3000 for external use.

3) Third part is Horizontal Pod Autoscaler (HPA) part which will make sure to scale pods based on metrics define in file.

Once you execute this file - 
```script
$ kubectl apply -f deployment-service-hpa.yaml
```
You are set to use the application...!
