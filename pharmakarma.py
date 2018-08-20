from flask import Flask, render_template
app = Flask(__name__)


@app.route('/')
def index():
    return render_template('home.html')

@app.route('/analysis')
def analysis():
    return render_template('analysis.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=80)
