from flask import Flask, render_template, make_response
from flask_wtf import FlaskForm
from wtforms import StringField,SubmitField
import pandas as pd
import numpy as np
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
import os.path
from datetime import datetime, timedelta
import random
import io
import time

app = Flask(__name__)
# Configure a secret SECRET_KEY
# We will later learn much better ways to do this!!
app.config['SECRET_KEY'] = 'mysecretkey'

class InfoForm(FlaskForm):
    '''
    This general class gets a lot of form about puppies.
    Mainly a way to go through many of the WTForms Fields.
    '''
    stockpick = StringField('Ticker placeholder is used instead')
    submit = SubmitField('Analyze')

@app.route('/', methods=['GET', 'POST'])

def index():
    stockpick = False
    # Create instance of the form.
    form = InfoForm()
    # If the form is valid on submission (we'll talk about validation next)
    if form.validate_on_submit():

        # Grab the data from the stockpick on the form.
        stockpick = form.stockpick.data.upper()
        # Reset the form's stockpick data to be False
        form.stockpick.data = ''


        one_hour_ago = datetime.now() - timedelta(hours=1)
        if os.path.exists("history.csv"):
            filetime = datetime.fromtimestamp(os.path.getctime("history.csv"))
            updateneeded="test"
            time.sleep(2)

            if filetime > one_hour_ago:

                histdata = pd.read_html("https://www.biopharmcatalyst.com/calendars/historical-catalyst-calendar")
                histdata[0].to_csv('history.csv',index=False)
        else:
            histdata = pd.read_html("https://www.biopharmcatalyst.com/calendars/historical-catalyst-calendar")
            histdata[0].to_csv('history.csv',index=False)
        df = pd.read_csv('history.csv').set_index('Ticker')
        df[["Date","Catalyst"]] = df.Catalyst.str.extract('(?P<Date>[0-9]{2}\/[0-9]{2}\/[0-9]{4})(?P<Catalyst>.*)', expand=True)
        data = df.loc[stockpick]
        pd.set_option('display.max_colwidth', -1)
        return render_template('view.html',form=form, updateneeded=updateneeded, tables=[data.to_html(classes="stockframe")])
    else:
        return render_template('home.html',form=form, stockpick=stockpick)

@app.route('/plot.png')
def plot():
    fig = Figure()
    axis = fig.add_subplot(1, 1, 1)

    xs = range(100)
    ys = [random.randint(1, 50) for x in xs]

    axis.plot(xs, ys)
    canvas = FigureCanvas(fig)
    output = io.BytesIO()
    canvas.print_png(output)
    response = make_response(output.getvalue())
    response.mimetype = 'image/png'
    return response

@app.route('/analysis')
def analysis():
    return render_template('analysis.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
