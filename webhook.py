from flask import Flask, request
import os

app = Flask(__name__)

@app.route('/update', methods=['POST'])
def update():
    os.system('cd /usr/share/nginx/html && git pull && nginx -s reload')
    return 'Updated', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)