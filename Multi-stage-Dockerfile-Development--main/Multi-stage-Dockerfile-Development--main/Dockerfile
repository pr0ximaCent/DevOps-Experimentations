# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . ./

# Build the React application
RUN npm run build

# Stage 2: Production Stage
FROM nginx:1.24-alpine

# Remove the default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the built files from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

