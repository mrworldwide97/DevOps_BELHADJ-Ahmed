from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    try:
        with open('Readme.md', 'r') as file:
            readme_content = file.read()
        return f"<h1>Readme Content</h1><p>{readme_content}</p>"
    except Exception as e:
        return f"<h1>Error</h1><p>{e}</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
