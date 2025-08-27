# Use official Node.js base image (small + includes npm/yarn)
FROM node:18-slim

# Install Tor only
RUN apt-get update && apt-get install -y tor tini \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy reverse proxy server
COPY server.js .

# Copy tor configuration
COPY torrc /etc/tor/torrc

# Fix permissions for hidden service
RUN mkdir -p /var/lib/tor/hidden_service \
    && chown -R debian-tor:debian-tor /var/lib/tor/hidden_service \
    && chmod 700 /var/lib/tor/hidden_service

# Expose hidden service port (80 inside onion)
EXPOSE 80

# Run tor + node together under tini
CMD ["tini", "--", "sh", "-c", "tor & node server.js"]
