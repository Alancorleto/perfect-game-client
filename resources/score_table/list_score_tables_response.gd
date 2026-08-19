class_name ListScoreTablesResponse
extends Serializable

var score_tables: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	score_tables.clear()
	for st_dict: Dictionary in from_dict["score_tables"]:
		score_tables.append(ScoreTable.new(st_dict))
