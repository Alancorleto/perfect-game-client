class_name RoundPanel
extends PanelContainer

signal pressed()

@onready var button: Button = %Button
@onready var move_button: Button = %MoveButton
@onready var name_panel: Label = %NamePanel
@onready var delete_button: TextureButton = %DeleteButton


func populate(round: Round) -> void:
	name_panel.text = round.name
	button.pressed.connect(pressed.emit)
