# Use the official Node.js image as the base image
FROM ghcr.io/puppeteer/puppeteer:21.7.0

# Set the working directory in the container
WORKDIR /home/pptruser

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# # Install dependencies
# RUN npm install

# Copy your Puppeteer script and .env file (if needed) to the container
COPY main.mjs ./
# COPY .env ./

# Start your script when the container starts
CMD ["node", "main.mjs"]
