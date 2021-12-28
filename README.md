<img src = "https://github.com/cezar-r/weedipedia/blob/main/assets/icon/AppIcon.png" height = 200 width = 200> 

# Weedipedia Mobile App

## Background
The marijuana industry is one of the fastest growing industries at the moment, with new strains and variants being created everyday. This application aims to be a companion app, containing information on over 7,500 strains.

## Data
All of the data was scraped from [Allbud](https://www.allbud.com/) using [BeautifulSoup4](https://pypi.org/project/beautifulsoup4/). The code for this can be found [here](https://github.com/cezar-r/weedipedia/blob/main/src/scraper.py). Each strain is then saved as a [strain](https://github.com/cezar-r/weedipedia/blob/main/src/strain.py) object, which are all stored in a list that is saved as a pickle file to preserve raw data. This data is then [converted to a json file](https://github.com/cezar-r/weedipedia/blob/main/src/datamanager.py)

## Display
 - Below are some examples of the app interface
 - <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6614.PNG' height = 600 width = 300> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6616.PNG' height = 600 width = 300> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6617.PNG' height = 600 width = 300> 

## User Preferences
 - One of the unique features of this app is how it allows the user to pick a theme color from over 56 colors.
- <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6618.PNG' height = 600 width = 300> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6619.PNG' height = 600 width = 300>
