

class Strain:

	def __init__(self, **kwargs):
		self.__dict__.update(kwargs)


	def __str__(self):
		retval = ''
		for k in self.__dict__:
			# if len(self.__dict__[k]) > 60:
			# 	retval += f'{k.title()} - {self.__dict__[k][:61]}...\n'
			# else:
			retval += f'{k.title()} - {self.__dict__[k]}\n\n'
		return retval