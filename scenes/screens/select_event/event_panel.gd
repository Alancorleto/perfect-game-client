class_name EventPanel
extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var date_label: Label = %DateLabel
@onready var location_label: Label = %LocationLabel
@onready var logo_rect: TextureRect = %LogoRect


func populate(event: EventResponse) -> void:
	name_label.text = event.name
	date_label.text = event.start_date
	location_label.text = event.location
