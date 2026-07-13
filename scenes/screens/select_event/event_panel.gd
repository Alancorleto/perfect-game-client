class_name EventPanel
extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var date_label: Label = %DateLabel
@onready var location_label: Label = %LocationLabel
@onready var logo_rect: TextureRect = %LogoRect
@onready var button: Button = %Button

const EVENT_SCREEN_SCENE_PATH := ""


func populate(event: Event) -> void:
	name_label.text = event.name
	date_label.text = event.start_date
	location_label.text = event.location
	logo_rect.texture = event.logo
	
	button.pressed.connect(_go_to_event_screen.bind(event))


func _go_to_event_screen(event: Event) -> void:
	Globals.current_event = event
	App.change_screen(EVENT_SCREEN_SCENE_PATH)
