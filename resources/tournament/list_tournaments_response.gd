class_name ListTournamentsResponse
extends Serializable

var tournaments: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	tournaments.clear()
	for t_dict: Dictionary in from_dict["tournaments"]:
		tournaments.append(Tournament.new(t_dict))
