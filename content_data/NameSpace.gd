extends Node

# =========================== Custom =========================== #
class Methods:
	static func format_number(number: int) -> String:
		if number < 1000:
			return str(number)
		
		elif number < 1000000:
			if number % 1000 == 0:
				return str(number / 1000) + "K"
			else:
				return str(stepify(float(number) / 1000, 0.01)) + "K"
		
		elif number < 1000000000:
			if number % 1000000 == 0:
				return str(number / 1000000) + "M"
			else:
				return str(stepify(float(number) / 1000000, 0.01)) + "M"
		
		elif number < 1000000000000:
			if number % 1000000000 == 0:
				return str(number / 1000000000) + "B"
			else:
				return str(stepify(float(number) / 1000000000, 0.01)) + "B"
		
		elif number < 1000000000000000:
			if number % 1000000000000 == 0:
				return str(number / 1000000000000) + "T"
			else:
				return str(stepify(float(number) / 1000000000000, 0.01)) + "T"
		
		else:
			if number % 1000000000000000 == 0:
				return str(number / 1000000000000000) + "P"
			else:
				return str(stepify(float(number) / 1000000000000000, 0.01)) + "P"

class Scripts:
	const ItemCharacterData = preload("res://mods-unpacked/Yoko-Optimize/content/scripts/item_character.gd")
