from flask import Flask, render_template
from flask_wtf import FlaskForm
from wtforms import StringField,SubmitField
import pandas as pd
import numpy as np
import os.path
from datetime import datetime, timedelta

app = Flask(__name__)
# Configure a secret SECRET_KEY
# We will later learn much better ways to do this!!
app.config['SECRET_KEY'] = 'mysecretkey'

class InfoForm(FlaskForm):
    '''
    This general class gets a lot of form about puppies.
    Mainly a way to go through many of the WTForms Fields.
    '''
    stockpick = StringField('What stockpick are you?')
    submit = SubmitField('Submit')

@app.route('/', methods=['GET', 'POST'])
# def show_tables():
#     one_hour_ago = datetime.now() - timedelta(hours=1)
#     df = pd.read_csv('history.csv').set_index('Ticker')
#     df[["Date","Catalyst"]] = df.Catalyst.str.extract('(?P<Date>[0-9]{2}\/[0-9]{2}\/[0-9]{4})(?P<Catalyst>.*)', expand=True)
def index():
    stockpick = False
    # Create instance of the form.
    form = InfoForm()
    # If the form is valid on submission (we'll talk about validation next)
    if form.validate_on_submit():
        # Grab the data from the stockpick on the form.
        stockpick = form.stockpick.data
        # Reset the form's stockpick data to be False
        form.stockpick.data = ''
    return render_template('home.html', form=form, stockpick=stockpick)

@app.route('/analysis')
def analysis():
    return render_template('analysis.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
