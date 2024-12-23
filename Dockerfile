# Step 1: Build the React app in a Node.js environment
FROM node:18 as build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm install --force

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Step 2: Set up Nginx to serve the built files
FROM nginx:stable-alpine

# Copy the React build files from the previous step to the Nginx web directory
COPY --from=build /app/build /usr/share/nginx/html

# Copy a custom Nginx configuration file, if necessary
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose the default Nginx HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]