extends Control

@onready var logo: TextureRect = %Logo
@onready var name_label: Label = %NameLabel
@onready var date_label: Label = %DateLabel
@onready var location_label: Label = %LocationLabel
@onready var description_label: Label = %DescriptionLabel

@onready var categories_container: VBoxContainer = %CategoriesContainer
@onready var new_category_button: Button = %NewCategoryButton

@onready var organizers_container: VBoxContainer = %OrganizersContainer
@onready var new_organizer_button: Button = %NewOrganizerButton


var event: Event


func _ready() -> void:
	event = Globals.current_event
	
	
	
