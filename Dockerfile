# Multi-stage build for Taiga deployment on Railway
FROM nginx:1.19-alpine

# Copy nginx configuration
COPY taiga-gateway/taiga.conf /etc/nginx/conf.d/default.conf

# Create directories for static and media files
RUN mkdir -p /taiga/static /taiga/media

# Set proper permissions
RUN chown -R nginx:nginx /taiga

# Expose port (Railway will set PORT env var)
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
