# React Application with Docker and Nginx

This project demonstrates how to containerize a React application using a multi-stage Dockerfile to optimize the final image size. Nginx is used to serve the static files for production.

## Features
- React application with a simple login page (email and password fields).
- Multi-stage Docker build for optimized image size.
- Nginx as the web server for serving the React application.

---

## Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed on your machine.
- Basic knowledge of React and Docker.

---

## Project Structure
```
project-directory/
|-- Dockerfile
|-- nginx/
|   |-- default.conf
|-- public/
|-- src/
|   |-- components/
|   |-- App.js
|   |-- index.js
|-- package.json
|-- README.md
```

### Key Files
- **Dockerfile**: The multi-stage Dockerfile for building and serving the React application.
- **nginx/default.conf**: The configuration file for Nginx to serve the React app.
- **src/**: Contains the source code for the React application.

---

## Dockerfile
The Dockerfile uses multi-stage builds to optimize the image size:

```Dockerfile
# Stage 1: Build React Application
FROM node:18 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd <repository-name>
```

### 2. Build the Docker Image
Run the following command to build the Docker image:
```bash
docker build -t react-docker-app .
```

### 3. Run the Docker Container
Run the container, mapping port `8080` on your host to port `80` in the container:
```bash
docker run -p 8080:80 --name react-docker-app-container react-docker-app
```

### 4. Access the Application
Open your browser and navigate to:
```
http://localhost:8080
```
You should see the React application.

---

## Updating the Application
If you make changes to the React application:
1. Rebuild the React app:
   ```bash
   npm run build
   ```
2. Rebuild the Docker image:
   ```bash
   docker build -t react-docker-app .
   ```
3. Stop and remove the old container:
   ```bash
   docker stop react-docker-app-container
   docker rm react-docker-app-container
   ```
4. Run the new container:
   ```bash
   docker run -p 8080:80 --name react-docker-app-container react-docker-app
   ```

---

## Image Size
To check the size of the built Docker image:
```bash
docker images react-docker-app
```

---

## Customization
### Modify Nginx Configuration
You can customize the Nginx configuration by editing the `nginx/default.conf` file.

Example default.conf:
```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri /index.html;
    }
}
```

### Use a Different Port
To use a different port, modify the `docker run` command. For example, to use port `5000`:
```bash
docker run -p 5000:80 --name react-docker-app-container react-docker-app
```
Access the app at:
```
http://localhost:5000
```

---

## Clean Up
To remove the Docker container and image:
1. Stop and remove the container:
   ```bash
   docker stop react-docker-app-container
   docker rm react-docker-app-container
   ```
2. Remove the image:
   ```bash
   docker rmi react-docker-app
   ```


