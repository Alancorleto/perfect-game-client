class_name RoundPanel
extends PanelContainer

@onready var button: Button = %Button
@onready var move_button: Button = %MoveButton
@onready var name_panel: Label = %NamePanel
@onready var delete_button: TextureButton = %DeleteButton

const SCORE_SUM_SCREEN_SCENE_PATH := "res://scenes/placeholder/screens/score_sum_screen.tscn"
const BATTLE_SCREEN_SCENE_PATH := "res://scenes/placeholder/screens/battle_screen.tscn"


func populate(round: Round) -> void:
	name_panel.text = round.name
	button.pressed.connect(_go_to_round.bind(round))


func _go_to_round(round: Round) -> void:
	Globals.current_round = round
	if round.format == "score_sum":
		App.change_screen(SCORE_SUM_SCREEN_SCENE_PATH)
	else:
		App.change_screen(BATTLE_SCREEN_SCENE_PATH)
