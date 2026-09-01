class_name EventOrganizerPanel
extends PanelContainer

signal delete_pressed()

@onready var button: Button = %Button
@onready var name_panel: Label = %NamePanel
@onready var delete_button: TextureButton = %DeleteButton
@onready var delete_button_margin: MarginContainer = %DeleteButtonMargin


func populate(organizer: Player) -> void:
	name_panel.text = organizer.nickname


func show_delete_button() -> void:
	delete_button_margin.show()


func _ready() -> void:
	delete_button.pressed.connect(delete_pressed.emit)
