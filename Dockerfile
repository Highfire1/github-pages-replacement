FROM nginx:alpine

# Install dependencies
RUN apk add --no-cache git python3 py3-pip

# Create and activate a virtual environment
RUN python3 -m venv /venv

# Install Flask inside the virtual environment
RUN /venv/bin/pip install flask

RUN rm -rf /usr/share/nginx/html/*

# Clone your repository
RUN git clone https://github.com/highfire1/highfire1.github.io.git /usr/share/nginx/html

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
CMD ["/venv/bin/python /webhook.py & nginx -g 'daemon off;'"]