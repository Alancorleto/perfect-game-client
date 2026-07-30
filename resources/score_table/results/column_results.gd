class_name ColumnResults
extends Serializable

var score_column_id = ""
var results: Array[Result] = []


func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)
	for result_dict: Dictionary in from_dict["results"]:
		results.append(Result.new(result_dict))
