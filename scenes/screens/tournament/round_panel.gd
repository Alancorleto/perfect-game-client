class_name RoundPanel
extends PanelContainer

@onready var button: Button = %Button
@onready var move_button: Button = %MoveButton
@onready var name_panel: Label = %NamePanel
@onready var delete_button: TextureButton = %DeleteButton

const ROUND_SCREEN_SCENE_PATH := "res://scenes/screens/round/round_screen.tscn"


func populate(round: Round) -> void:
	name_panel.text = round.name
	button.pressed.connect(_go_to_round.bind(round))


func _go_to_round(round: Round) -> void:
	Globals.current_round = round
	App.change_screen(ROUND_SCREEN_SCENE_PATH)
