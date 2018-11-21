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

one_hour_ago = datetime.now() - timedelta(hours=1)

if os.path.exists("history.csv"):
    filetime = datetime.fromtimestamp(os.path.getmtime("history.csv"))
    print(filetime)
    print(one_hour_ago)
    if filetime < one_hour_ago:
        # global updateneeded
        updateneeded = True
    else:
        updateneeded = False
else:
    updateneeded = True
print(updateneeded)
