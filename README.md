
# DevOps Monorepo

A unified repository demonstrating key DevOps patterns: optimized container builds, CI/CD automation, advanced network isolation, and Kubernetes ingress routing.

## Project Links

- [Multi-stage Dockerfile Development](https://github.com/pr0ximaCent/Multi-stage-Dockerfile-Development-)  
- [CI-CD Pipeline Implementation](https://github.com/pr0ximaCent/-CI-CD-Pipeline-Implementation)  
- [Custom Network Configuration](https://github.com/pr0ximaCent/Custom-Network-Configuration)  
- [Ingress Controller Setup](https://github.com/pr0ximaCent/Ingress-Controller-Setup)  

---

## Table of Contents

1. [About](#about)  
2. [Projects](#projects)  
3. [Prerequisites](#prerequisites)  
4. [Getting Started](#getting-started)  
   - [Containerized Frontend Deployment](#containerized-frontend-deployment)  
   - [CI/CD Pipeline](#ci-cd-pipeline)  
   - [Custom Bridge Networking](#custom-bridge-networking)  
   - [Kubernetes Ingress Routing](#kubernetes-ingress-routing)  
5. [Contributing](#contributing)  
6. [License](#license)  

---

## About

This monorepo brings together four essential DevOps projects:

- **Containerized Frontend Deployment**  
  Builds and serves a React app using a multi-stage Dockerfile and Nginx for lightweight production images.

- **Automated CI/CD Pipeline**  
  Implements GitHub Actions workflows to test, build Docker images, and deploy to staging via Docker Compose with secure handling of secrets.

- **Isolated Bridge Networking**  
  Uses Linux network namespaces, a custom bridge (`br_custom`), and iptables to provide isolated egress-controlled environments, all automated via shell scripts and a Makefile.

- **Kubernetes Ingress Routing**  
  Deploys Dockerized React (frontend) and Node.js (backend) services to Kubernetes, using the Nginx Ingress Controller for domain-based traffic routing.

---

## Projects

| Directory                          | Description                                                                 |
|------------------------------------|-----------------------------------------------------------------------------|
| `frontend-docker/`                 | React app with multi-stage Dockerfile & Nginx serving static files          |
| `ci-cd-pipeline/`                  | GitHub Actions workflows for building, testing, and deploying Docker images |
| `bridge-network/`                  | Scripts to create a custom bridge, namespace setup, and iptables NAT rules  |
| `k8s-ingress-example/`             | Kubernetes manifests & Docker Compose for Ingress routing demo              |

---

## Prerequisites

- **Docker** (v20.10+)  
- **Docker Compose** (v1.29+)  
- **GitHub Actions** (for CI/CD pipelines)  
- **Linux** with `iproute2` and `iptables` (for bridge networking)  
- **kubectl** & **Kubernetes cluster** (for Ingress demo)  
- **Make** (for automation in bridge-network project)

---

## Getting Started

Clone this repository and explore each sub-project:

```bash
git clone https://github.com/your-org/devops-monorepo.git
cd devops-monorepo
````

### Containerized Frontend Deployment

```bash
cd frontend-docker
# Build the image
docker build -t react-docker-app .
# Run the container (exposes port 8080 → 80)
docker run -p 8080:80 --name react-docker-app-container react-docker-app
```

### CI/CD Pipeline

1. Open the `.github/workflows/` directory.
2. Review `ci.yml` and `cd.yml` for testing, build, and deploy stages.
3. Push a PR to trigger tests; merging to `main` will build and deploy to staging via Docker Compose.

### Custom Bridge Networking

```bash
cd bridge-network
# Create network & namespace, then test connectivity
make all
# When done, clean up
make clean
```

Scripts:

* `scripts/create_bridge.sh`
* `scripts/setup_namespace.sh`
* `Makefile` automates the steps.

### Kubernetes Ingress Routing

```bash
cd k8s-ingress-example

# 1. Deploy the Nginx Ingress Controller
kubectl apply -f k8s/nginx-ingress.yaml

# 2. Build & deploy backend
cd backend
docker build -t my-backend .
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml

# 3. Build & deploy frontend
cd ../frontend
docker build -t my-frontend .
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml

# 4. Apply ingress rules
cd ..
kubectl apply -f k8s/ingress.yaml

# (Optional) Local test via docker-compose
docker-compose up --build
```

Access:

* Frontend → `http://localhost:8080`
* Backend  → `http://localhost:3000`

---

## Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/XYZ`)
3. Commit your changes and push (`git push origin feature/XYZ`)
4. Open a Pull Request

Please follow the existing code style and include tests where applicable.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

```
```
