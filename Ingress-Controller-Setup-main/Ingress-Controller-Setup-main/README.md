# Kubernetes Ingress Example with React and Node.js

## Folder Structure

```
my-app/
├── backend/
│   ├── Dockerfile
│   ├── app.js
│   └── k8s/
│       ├── backend-deployment.yaml
│       └── backend-service.yaml
├── frontend/
│   ├── Dockerfile
│   └── build/
│       ├── index.html
│       └── static/
├── k8s/
│   ├── ingress.yaml
│   └── nginx-ingress.yaml
├── README.md
└── docker-compose.yaml
```

## Steps to Set Up Locally

### 1. Set up Kubernetes Ingress Controller

- Apply the Nginx Ingress Controller:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

### 2. Build and Deploy Backend and Frontend Applications

1. **Backend:**
   - Navigate to the `backend` folder and run:
```bash
docker build -t <your-backend-image> .
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml
```

2. **Frontend:**
   - Navigate to the `frontend` folder and run:
```bash
docker build -t <your-frontend-image> .
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml
```

### 3. Apply the Ingress Rules

- Apply the Ingress:
```bash
kubectl apply -f k8s/ingress.yaml
```

### 4. Testing Locally with Docker Compose

1. Run `docker-compose up --build` in the root directory.
2. Access the apps locally:
   - Frontend: http://localhost:8080
   - Backend: http://localhost:3000
