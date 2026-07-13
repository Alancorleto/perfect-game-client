extends PanelContainer

@onready var button: Button = %Button
@onready var move_button: Button = %MoveButton
@onready var name_panel: Label = %NamePanel
@onready var delete_button: TextureButton = %DeleteButton

const TOURNAMENT_SCREEN_SCENE_PATH := ""


func populate(tournament: Tournament) -> void:
	name_panel.text = tournament.name
	button.pressed.connect(_go_to_tournament.bind(tournament))


func _go_to_tournament(tournament: Tournament) -> void:
	Globals.current_tournament = tournament
	App.change_screen(TOURNAMENT_SCREEN_SCENE_PATH)
