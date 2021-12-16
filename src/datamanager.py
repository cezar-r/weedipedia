import json

def to_json(data, filename = '../assets/data.json'): # list of Strain() objects
	# data = [strain.__dict__ for strain in data]
	if data == []:
	    return
	data = reformat(data)
	json_str = json.dumps(data)
	with open(filename, 'w') as json_file:
		json_file.write(json_str)
	json_file.close()

def reformat(data):
	new_data = []
	for strain in data:
		new_strain = {}
		for key in strain.__dict__:
			if key == 'thc_cbd_pct':
				thc_pct, cbd_pct, cbn_pct = get_pcts(strain.__dict__[key])
				new_strain['thc_pct'] = thc_pct
				new_strain['cbd_pct'] = cbd_pct
				new_strain['cbn_pct'] = cbn_pct
			elif key == 'strain_type':
				strain_type, strain_type_strength = get_type_data(strain.__dict__[key])
				new_strain['strain_type'] = strain_type 
				new_strain['strain_type_strength'] = strain_type_strength
			else:
				new_strain[key] = strain.__dict__[key]
		new_data.append(new_strain)
	return new_data


def get_type_data(strain_type_string):
	strain_type_split = strain_type_string.split(' - ')
	try:
		return strain_type_split[0], strain_type_split[1]
	except:
		return strain_type_string, "100% " + strain_type_string

def get_pcts(pct_string): # 'THC: 1%, CBD: 15%'
	pct_string_split = pct_string.split(', ') # ['THC: 1%', 'CBD: 15%']
	thc_pct, cbd_pct, cbn_pct, = '-', '-', '-'
	for pct in pct_string_split:
		if pct[:3] == 'THC':
			thc_pct = pct[4:]
		elif pct[:3] == 'CBD':
			cbd_pct = pct[4:]
		elif pct[:3] == 'CBN':
			cbn_pct = pct[4:]
	return thc_pct, cbd_pct, cbn_pct

def read_json(filename = '../assets/data.json'):
	with open(filename, 'r') as openfile:
		json_obj = json.load(openfile)
	print(json_obj)


if __name__ == '__main__':
    pass