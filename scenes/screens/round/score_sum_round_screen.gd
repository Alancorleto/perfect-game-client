class_name ScoreSumRoundScreen
extends Control

var round: Round
var score_table: ScoreTable


func _ready() -> void:
	round = Globals.current_round
	var score_tables: Array[ScoreTable] = await RoundsRouter.list_score_tables_in_round(round.id)

	if score_tables.size() == 0:
		return

	score_table = score_tables[0]
