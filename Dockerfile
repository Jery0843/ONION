# Base image
FROM debian:bullseye-slim

# Install dependencies (tor + curl + node + tini for process management)
RUN apt-get update && apt-get install -y \
    tor \
    curl \
    nodejs \
    npm \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy reverse proxy server
COPY server.js .

# Copy tor configuration
COPY torrc /etc/tor/torrc

# Expose the hidden service port (80 for .onion)
EXPOSE 80

# Run tor + node together
CMD ["tini", "--", "sh", "-c", "tor & node server.js"]
