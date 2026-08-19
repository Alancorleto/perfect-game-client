class_name ListRoundsResponse
extends Serializable

var rounds: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	rounds.clear()
	for r_dict: Dictionary in from_dict["rounds"]:
		rounds.append(Round.new(r_dict))
