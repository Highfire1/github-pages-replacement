FROM nginx:alpine

# Install dependencies
RUN apk add --no-cache git python3 py3-pip

# Create and activate a virtual environment
RUN python3 -m venv /venv

# Install Flask and gitpython inside the virtual environment
RUN /venv/bin/pip install flask gitpython

# Remove existing contents in the Nginx HTML directory
RUN rm -rf /usr/share/nginx/html/*

# Clone your repository
RUN git clone https://github.com/highfire1/highfire1.github.io.git /usr/share/nginx/html

# Set the working directory
WORKDIR /usr/share/nginx/html

# Copy webhook script
COPY webhook.py /webhook.py

# Expose the webhook port
EXPOSE 5000

# Start the Flask app and Nginx
CMD ["/bin/sh", "-c", "/venv/bin/python /webhook.py & nginx -g 'daemon off;'"]