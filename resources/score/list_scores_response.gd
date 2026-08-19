class_name ListScoresResponse
extends Serializable

var scores: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	scores.clear()
	for s_dict: Dictionary in from_dict["scores"]:
		scores.append(ScoreResponse.new(s_dict))
