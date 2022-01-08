<img src = "https://github.com/cezar-r/weedipedia/blob/main/assets/icon/AppIcon.png" height = 200 width = 200> 

# Weedipedia Mobile App

## Background
The marijuana industry is one of the fastest growing industries at the moment, with new strains and variants being created everyday. This application aims to be a companion app, containing information on over 7,500 strains.

## Data
All of the marijuana strain data was scraped from [Allbud](https://www.allbud.com/) using [BeautifulSoup4](https://pypi.org/project/beautifulsoup4/). The code for this can be found [here](https://github.com/cezar-r/weedipedia/blob/main/src/scraper.py). Each strain is then saved as a [strain](https://github.com/cezar-r/weedipedia/blob/main/src/strain.py) object, which are all stored in a list that is saved as a pickle file to preserve raw data. This data is then [converted to a json file](https://github.com/cezar-r/weedipedia/blob/main/src/datamanager.py)

## Search
 - Below are some examples of the app interface when searching
 - <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6704.PNG' height = 420 width = 200> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6705.PNG' height = 420 width = 200> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6706.PNG' height = 420 width = 200> 

## Conversion
 - This app allows the user to convert different metrics of weight, which are updated on input change.
 - <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6707.PNG' height = 420 width = 200> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6726.PNG' height = 420 width = 200> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6723.PNG' height = 420 width = 200>

## Profile Page
 - Lastly, there is a profile page that contains all of the users favorited strains and color preferences.
 - <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6708.PNG' height = 420 width = 200> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6724.PNG' height = 420 width = 200>

## User Preferences
 - One of the unique features of this app is how it allows the user to pick a theme color from over 56 colors.
 - <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6710.PNG' height = 420 width = 200> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6711.PNG' height = 420 width = 200> <img src = 'https://github.com/cezar-r/weedipedia/blob/main/assets/IMG-6725.PNG' height = 420 width = 200>

## TODO
 - There are still a few updates needed to be made before the app is ready to hit the App Store. Here are some of the updates coming soon:
   - Recent searches - The app will display recent searches made by the user

## Technologies Used
 - BeautifulSoup4
 - Flutter 
