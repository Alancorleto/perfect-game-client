class_name Result
extends Serializable

var player_order_index = 0
var score: ResultScore
var place: int = -1


func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)
	score = ResultScore.new(from_dict["score"])
