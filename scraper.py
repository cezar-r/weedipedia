

# S_URL = 'http://api.scraperapi.com?api_key=800a43e7386a5a4f5801c8762c3a4aab&url='


from string import ascii_lowercase
from bs4 import BeautifulSoup
from itertools import takewhile
import requests
import re
import pickle
import os
from strain import Strain

class Scraper:

	def __init__(self, verbose = True, autoscrape = False, autosave = True):
		self.data = []
		self.verbose = verbose
		if autoscrape:
			self._scrape()
		if autosave:
			if self.verbose:
				print('Saving...')
			self.save()
			if self.verbose:
				print('Saved!')


	def save(self):
		with open('data.pkl', 'wb') as file:
			pickle.dump(self.data, file)


	def load_data(self):
		with open('data.pkl', 'rb') as file:
			data = pickle.load(file)
			return data


	def _scrape(self):
		counter = 1
		for letter in ascii_lowercase:
			url = f'https://www.allbud.com/marijuana-strains/search?sort=alphabet&letter={letter.upper()}&results=2000'
			source = requests.get(url).text
			soup = BeautifulSoup(source, 'html.parser')
			for strain in soup.find_all('div', class_ ='col-sm-6 col-md-4 col-lg-3'):
				strain_url = strain.article.header.a['href']
				strain_page_url = 'https://www.allbud.com' + strain_url
				print(counter)
				strain = self._get_strain_info(strain_page_url)
				counter += 1
				self.data.append(strain)

	def _get_strain_info(self, url):
		try:
			source = requests.get(url).text
			soup = BeautifulSoup(source, 'html.parser')
			name = self._get_strain_name(soup)
			thc_cbd_pct = self._get_thc_cbd_pct(soup)
			strain_type = self._get_strain_type(soup)
			review = self._get_strain_review(soup)
			effects, reliefs, flavors, aromas = self._get_strain_effects(soup)
			strain = Strain(name = name, 
							strain_type = strain_type, 
							thc_cbd_pct = thc_cbd_pct, 
							review = review, 
							effects = effects,
							reliefs = reliefs,
							flavors = flavors,
							aromas = aromas, 
							source = url)
			if self.verbose:
				print(strain)
			return strain
		except:
			return Strain()

	def _get_strain_name(self, soup):
		div = soup.find(id = 'strain_detail_accordion')
		return div.h1.text.strip()

	def _get_thc_cbd_pct(self, soup):
		div = soup.find('h4', class_ = 'percentage')
		text = div.text
		thc_pct = re.sub("\s{4,}", " ", text).strip()
		return thc_pct

	def _get_strain_type(self, soup):
		div = soup.find('h4', class_ = 'variety')
		text = div.text
		strain_type = re.sub("\s{4,}", " ", text).strip()
		return strain_type

	def _get_strain_review(self, soup):
		div = soup.find('div', class_ = 'panel-body well description')
		text = div.text
		review = " ".join(list(takewhile(lambda x: x != '' and '\n' not in x, text.split(' ')[::-1]))[::-1])
		return review

	def _get_strain_effects(self, soup):
		divs = soup.find_all('div', class_ = 'panel-body well tags-list')
		data = []
		for div in divs:
			text = div.text
			data.append(re.sub("\s{4,}", " ", text).strip())
			# data.append(re.sub("\s{4,}", " ", text).strip().split(', '))
		return data[0], data[1], data[2], data[3]


def lookup(strain):
	os.system('cls' if os.name == 'nt' else 'clear')
	scraper = Scraper(autosave = False)
	data = scraper.load_data()
	for strain_ in data:
		try:
			if strain_.name.lower().startswith(strain.lower()):
				print(f"Results for {strain}:\n{strain_}")
				# print(strain_)
		except:
			pass


if __name__ == '__main__':
	os.system('cls' if os.name == 'nt' else 'clear')
	strain = input("Enter strain:\n")
	lookup(strain)
