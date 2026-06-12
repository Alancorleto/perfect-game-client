class_name Serializable
extends Resource


func _init(from_dict: Dictionary = {}) -> void:
	if not from_dict.keys().is_empty():
		for key in from_dict.keys():
			set(key, from_dict[key])


func to_dictionary() -> Dictionary:
	var dict: Dictionary = {}
	for property: Dictionary in get_script().get_script_property_list():
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			dict[property["name"]] = get(property["name"])
	return dict
