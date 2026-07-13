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

const TournamentPanelScene := preload("res://scenes/screens/event/tournament_panel.tscn")


func _ready() -> void:
	App.show_loading_sign("Loading event...")

	event = Globals.current_event

	var tournaments: Array[Tournament] = await EventsRouter.list_event_tournaments(event.id)
	if tournaments.is_empty():
		var no_tournaments_label: Label = Label.new()
		no_tournaments_label.text = "No tournaments available."
		categories_container.add_child(no_tournaments_label)
	else:
		for tournament: Tournament in tournaments:
			var tournament_panel: TournamentPanel = TournamentPanelScene.instantiate()
			categories_container.add_child(tournament_panel)
			tournament_panel.populate(tournament)

	App.hide_loading_sign()
