# Website Server

This is a self hosted dropin replacement for Github Pages

This makes it easy to self host a website through a docker compose file.

Example Docker Compose File:
```yml
services:

  your-website:
    container_name: your-website
    ports:
      - '5000:5000' # Flask on port 5000
      - '5001:80' # nginx from port 80 in container -> port 5001 on host machine
    image: 'ghcr.io/highfire1/github-pages-replacement:latest'
    environment:
      - WEBHOOK_PASSWORD=your_secure_password_here
```