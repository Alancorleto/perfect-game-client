class_name ScoreColumnPanel
extends VBoxContainer

const ResultPanelScene := preload("res://scenes/screens/round/result_panel.tscn")

@onready var results_container: VBoxContainer = %ResultsContainer

var description: String = ""


func populate(column_results: ColumnResults, player_standings: Array[PlayerStanding]) -> void:
	description = column_results.description
	for result: Result in column_results.results:
		var result_panel: ResultPanel = ResultPanelScene.instantiate()
		var player_standing: PlayerStanding = player_standings[result.player_order_index]
		results_container.add_child(result_panel)
		result_panel.populate(result, player_standing)


func populate_total(total_results: Array[TotalResult], player_standings: Array[PlayerStanding]) -> void:
	description = "Total"
	for total_result: TotalResult in total_results:
		var result_panel: ResultPanel = ResultPanelScene.instantiate()
		var player_standing: PlayerStanding = player_standings[total_result.player_order_index]
		results_container.add_child(result_panel)
		result_panel.populate_total_result(total_result, player_standing)
