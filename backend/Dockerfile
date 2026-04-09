# Use Node 18 image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy source code
COPY server.js ./

# Expose port 5000
EXPOSE 5000

# Run the server
CMD ["node", "server.js"]
