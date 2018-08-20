import requests
from bs4 import BeautifulSoup
import os.path
from datetime import datetime, timedelta
import pkfunctions
# Scraping HTML pages
# https://www.dataquest.io/blog/web-scraping-tutorial-python/

# Read and write files
# https://www.digitalocean.com/community/tutorials/how-to-handle-plain-text-files-in-python-3
# page = requests.get("http://dataquestio.github.io/web-scraping-pages/simple.html")
cal_path = 'historical-catalyst-calendar'
one_hour_ago = datetime.now() - timedelta(hours=1)

if os.path.exists(cal_path):
    filetime = datetime.fromtimestamp(os.path.getctime(cal_path))
    if filetime < one_hour_ago:
        print("File is more than one hour old.")
        pkfunctions.hist_cal()
    else:
        print("The file doesn't need to be downloaded.")
else:
    pkfunctions.hist_cal()

f = open(cal_path, 'r', encoding='utf-8')
s = f.read()
soup = BeautifulSoup(s,'lxml')
print(soup)
# page = requests.get(cal_path)
# print(page.content)

# soup = BeautifulSoup(page.content, 'html.parser')
# print(soup)
# print(soup.prettify())
# html = list(soup.children)[0]
# html = list(soup.children)[2]
# print(html)
