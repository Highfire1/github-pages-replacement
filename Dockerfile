FROM nginx:alpine

# Install dependencies
RUN apk add --no-cache git python3 py3-pip
RUN pip3 install flask

# Clone your repository
RUN git clone https://github.com/username/repository.git /usr/share/nginx/html

# Set the working directory
WORKDIR /usr/share/nginx/html

# Copy webhook script
COPY webhook.py /webhook.py

# Make a script to update the repo and restart nginx
# RUN echo "*/5 * * * * cd /usr/share/nginx/html && git pull && nginx -s reload" > /etc/crontabs/root

# Expose the webhook port
EXPOSE 5000

# Start the cron, flask, and nginx in foreground
# CMD ["sh", "-c", "crond && python3 /webhook.py & nginx -g 'daemon off;'"]
CMD ["python3 /webhook.py & nginx -g 'daemon off;'"]