from scraper import Scraper
from datamanager import to_json, read_json

filename = '../assets/data2.json'

def main():
    scraper = Scraper(autosave = False)
#   scraper.save() -> saves data in pickle file
    scraper.scrape() # or Scraper(autoscrape = True)
	data = scraper.data # or scraper.load_data()
	to_json(data, filename)
	read_json(filename)

if __name__ == '__main__':
	main()




