class_name Results
extends Serializable

var player_standings: Array[PlayerStanding] = []
var columns_results: Array[ColumnResults] = []
var total_results: Array[TotalResult] = []


func _init(from_dict: Dictionary = {}) -> void:
	for player_standing_dict: Dictionary in from_dict["player_standings"]:
		player_standings.append(PlayerStanding.new(player_standing_dict))
	
	for column_results_dict: Dictionary in from_dict["columns_results"]:
		columns_results.append(ColumnResults.new(column_results_dict))
	
	for total_result_dict: Dictionary in from_dict["total_results"]:
		total_results.append(TotalResult.new(total_result_dict))
