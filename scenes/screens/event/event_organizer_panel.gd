class_name EventOrganizerPanel
extends PanelContainer

@onready var button: Button = %Button
@onready var name_panel: Label = %NamePanel
@onready var delete_button: TextureButton = %DeleteButton

const TOURNAMENT_SCREEN_SCENE_PATH := ""


func populate(organizer: Player) -> void:
	name_panel.text = organizer.nickname
