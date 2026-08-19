class_name ListScoreColumnsResponse
extends Serializable

var score_columns: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	score_columns.clear()
	for sc_dict: Dictionary in from_dict["score_columns"]:
		score_columns.append(ScoreColumnResponse.new(sc_dict))
