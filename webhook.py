from flask import Flask, request, render_template_string
import os
import subprocess
import git

app = Flask(__name__)

# Get the password from environment variable
WEBHOOK_PASSWORD = os.environ.get('WEBHOOK_PASSWORD')

@app.route('/')
def index():
    repo_dir = '/usr/share/nginx/html'
    if os.path.exists(repo_dir) and os.listdir(repo_dir):
        status = "Content has been set."
    else:
        status = "No content has been set yet."
    
    form_html = '''
    <form action="/update" method="post">
        <label for="git_url">Git Repository URL:</label><br>
        <input type="text" id="git_url" name="git_url" required><br>
        <label for="password">Password:</label><br>
        <input type="password" id="password" name="password" required><br>
        <input type="submit" value="Update Content">
    </form>
    '''
    
    return render_template_string(f'''
        <h1>Welcome</h1>
        <p>{status}</p>
        <h2>Update Content</h2>
        {form_html}
    ''')

@app.route('/update', methods=['POST'])
def update():
    # Check password
    if request.form.get('password') != WEBHOOK_PASSWORD:
        return 'Unauthorized', 401

    git_url = request.form.get('git_url')
    if not git_url:
        return 'Git URL is required', 400

    try:
        repo_dir = '/usr/share/nginx/html'
        if os.path.exists(repo_dir):
            repo = git.Repo(repo_dir)
            if repo.remote().url != git_url:
                os.system(f'rm -rf {repo_dir}/*')
                git.Repo.clone_from(git_url, repo_dir)
            else:
                repo.remotes.origin.pull()
        else:
            git.Repo.clone_from(git_url, repo_dir)

        subprocess.run(['nginx', '-s', 'reload'])
        return 'Updated successfully', 200
    except Exception as e:
        return f'Error: {str(e)}', 500

@app.errorhandler(404)
def not_found(error):
    return render_template_string('<h1>404 Not Found</h1><p>The requested page does not exist.</p>'), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)