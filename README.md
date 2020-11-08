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
    ```script
    FROM node:12                  // Image for node:12

    WORKDIR /usr/share/app        // Creating workdir

    COPY package*.json ./         // Copying package.json file to workdir ( ./app )
    
    RUN npm install               // Installing all the dependencies and packages 

    COPY . .                      // Copy files to ./app

    EXPOSE 8080                   // Exposing Conatainer to port 8080

    CMD ["node", "server.js"]     // Starting the application
    ```

After creating Dockerfile, build it - 
```script
$ docker build -t docker451001/nodejs-test . 
```
Once build is complete, push it to docker repo - 
```script
$ docker push docker451001/nodejs-test
```
Now, We are done with docker parts, Let's see the deployment, service and Hpa files - 
```script
$ Deployment.yaml

$ Service.yaml

$ Hpa.yaml
```

1) Deloyment.yaml file will create nodejs-test application ( which is hosted in Docker451001/nodejs-test repository ) with 10 replicas.

2) Service.yaml file will expose the pods to port 3000 for external use.

3) Hpa.yaml file will make sure to scale pods based on metrics define in file.

I have created single file for all the three executions to overcome deploying these file again and again.
```script
$ deployment-service-hpa.yaml
```

You are all set to use the application...!

