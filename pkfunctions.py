import wget

def hist_cal():
    hist_url = 'https://www.biopharmcatalyst.com/calendars/historical-catalyst-calendar'
    filename = wget.download(hist_url)
