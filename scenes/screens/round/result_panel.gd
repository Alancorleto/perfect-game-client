class_name ResultPanel
extends HBoxContainer

@onready var place_label: Label = $PlaceLabel
@onready var nickname_label: Label = $NicknameLabel
@onready var score_label: Label = $ScoreLabel


func populate(result: Result, player_standing: PlayerStanding) -> void:
	place_label.text = str(result.place)
	nickname_label.text = str(player_standing.nickname)
	score_label.text = str(result.score.value)


func populate_total_result(total_result: TotalResult, player_standing: PlayerStanding) -> void:
	place_label.text = str(total_result.place)
	nickname_label.text = str(player_standing.nickname)
	score_label.text = str(total_result.score)
