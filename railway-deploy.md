# Railway Deployment Guide for Taiga

## Important Note About Railway's Multi-Service Architecture

Railway has moved away from supporting docker-compose files directly. For this complex multi-service Taiga application, you have several deployment options:

## Option 1: Single Service Deployment (Recommended for Railway)

Due to Railway's architecture, the most practical approach is to deploy this as separate services and use Railway's managed PostgreSQL.

### Prerequisites

1. Railway account at [railway.app](https://railway.app)
2. Railway CLI installed: `npm install -g @railway/cli`
3. GitHub repository with your code

### Step 1: Prepare Your Repository

1. Push this project to a GitHub repository
2. Make sure the `railway.env` file contains your environment variables

### Step 2: Deploy to Railway

1. **Create a new Railway project:**
   ```bash
   railway login
   railway init
   ```

2. **Add PostgreSQL Database:**
   - In Railway dashboard, click "Add Service"
   - Select "Database" → "PostgreSQL"
   - Railway will automatically create and configure the database

3. **Deploy the main application:**
   - In Railway dashboard, click "Add Service"
   - Select "GitHub Repo" and connect your repository
   - Railway will detect the Dockerfile and deploy

### Step 3: Configure Environment Variables

In your Railway service settings, add these environment variables:

```bash
# Database (Railway will provide DATABASE_URL automatically)
POSTGRES_USER=taiga
POSTGRES_PASSWORD=your-secure-password
POSTGRES_DB=taiga

# Domain (Update with your Railway domain)
TAIGA_SCHEME=https
TAIGA_DOMAIN=your-service-name.railway.app
SUBPATH=""
WEBSOCKETS_SCHEME=wss

# Security
SECRET_KEY=your-very-secure-secret-key-generate-a-new-one

# Email
EMAIL_BACKEND=console
EMAIL_USE_TLS=True
EMAIL_USE_SSL=False

# RabbitMQ
RABBITMQ_USER=taiga
RABBITMQ_PASS=secure-rabbitmq-password
RABBITMQ_VHOST=taiga
RABBITMQ_ERLANG_COOKIE=unique-erlang-cookie

# Other
ATTACHMENTS_MAX_AGE=360
ENABLE_TELEMETRY=True
PORT=8000
```

## Option 2: External Multi-Service Platform

For a full multi-service deployment, consider these alternatives:

1. **DigitalOcean App Platform** - Supports docker-compose
2. **Google Cloud Run** - Can deploy multiple services
3. **AWS ECS** - Full container orchestration
4. **Self-hosted VPS** - Full control with Docker Compose

## Option 3: Modified Single Container Approach

Create a single container that includes all services using supervisord:

1. Create a new Dockerfile that combines all services
2. Use supervisord to manage multiple processes
3. Include PostgreSQL and RabbitMQ in the container

This is more complex but would work on Railway's single-service model.

## Post-Deployment Steps

1. **Create superuser:**
   ```bash
   railway run python manage.py createsuperuser
   ```

2. **Run migrations:**
   ```bash
   railway run python manage.py migrate
   ```

3. **Collect static files:**
   ```bash
   railway run python manage.py collectstatic --noinput
   ```

## Production Considerations

1. **Use managed databases** - Railway PostgreSQL is recommended
2. **Set strong passwords** - Generate secure random passwords
3. **Configure email** - Set up proper SMTP for production
4. **Enable HTTPS** - Railway provides this automatically
5. **Monitor logs** - Use Railway's built-in logging

## Troubleshooting

- Check Railway service logs for errors
- Verify all environment variables are set correctly
- Ensure database connection is working
- Test WebSocket connections for real-time features
