from flask import Flask, json, request, make_response, render_template

app = Flask(__name__, template_folder='html', static_folder='static')

@app.route('/')
def return_index():
    return render_template("index.html")