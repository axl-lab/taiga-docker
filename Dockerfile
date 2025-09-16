FROM nginx:1.19-alpine

# Copy the nginx configuration
COPY taiga-gateway/taiga.conf /etc/nginx/conf.d/default.conf

# Create directories for static and media files
RUN mkdir -p /taiga/static /taiga/media

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]