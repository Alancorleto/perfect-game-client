class_name ColumnResults
extends Serializable

var score_column_id = ""
var description: String = ""
var chart: ChartResponse
var results: Array[Result] = []


func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)
	chart = ChartResponse.new(from_dict["chart"])
	for result_dict: Dictionary in from_dict["results"]:
		results.append(Result.new(result_dict))
