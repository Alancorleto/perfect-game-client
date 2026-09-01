extends Control

@onready var logo: TextureRect = %Logo
@onready var name_label: Label = %NameLabel
@onready var date_label: Label = %DateLabel
@onready var location_label: Label = %LocationLabel
@onready var description_label: Label = %DescriptionLabel

@onready var update_button: Button = %UpdateButton

@onready var tournaments_container: VBoxContainer = %TournamentsContainer
@onready var new_tournament_button: Button = %NewTournamentButton

@onready var organizers_container: VBoxContainer = %OrganizersContainer
@onready var new_organizer_button: Button = %NewOrganizerButton

var event: Event

const UPDATE_EVENT_DATA_SCREEN_PATH: String = "res://scenes/screens/event/update_event_data_screen.tscn"
const ADD_ORGANIZER_SCREEN_PATH: String = "res://scenes/screens/add_organizer/add_organizer_screen.tscn"

const TournamentPanelScene := preload("res://scenes/screens/event/tournament_panel.tscn")
const EventOrganizerPanelScene := preload("res://scenes/screens/event/event_organizer_panel.tscn")


func _ready() -> void:
	update_button.pressed.connect(_go_to_update_event_data_screen)
	new_organizer_button.pressed.connect(_go_to_add_organizer_screen)
	
	App.show_loading_sign("Loading event...")

	event = Globals.current_event

	name_label.text = event.name
	date_label.text = event.start_date
	location_label.text = event.location
	description_label.text = event.description
	logo.texture = event.logo

	await _populate_tournaments()

	await _populate_organizers()

	if Globals.organizer_mode_enabled:
		update_button.show()
		new_organizer_button.show()
	else:
		update_button.hide()
		new_organizer_button.hide()

	App.hide_loading_sign()


func _populate_tournaments() -> void:
	for child in tournaments_container.get_children():
		tournaments_container.remove_child(child)
		child.queue_free()

	var tournaments: Array[Tournament] = await EventsRouter.list_event_tournaments(event.id)
	if tournaments.is_empty():
		var no_tournaments_label: Label = Label.new()
		no_tournaments_label.text = "No tournaments available."
		tournaments_container.add_child(no_tournaments_label)
	else:
		for tournament: Tournament in tournaments:
			var tournament_panel: TournamentPanel = TournamentPanelScene.instantiate()
			tournaments_container.add_child(tournament_panel)
			tournament_panel.populate(tournament)


func _populate_organizers() -> void:
	for child in organizers_container.get_children():
		organizers_container.remove_child(child)
		child.queue_free()

	var organizers: Array[Player] = await EventsRouter.list_event_organizers(event.id)
	if organizers.is_empty():
		var no_organizers_label: Label = Label.new()
		no_organizers_label.text = "No organizers available."
		organizers_container.add_child(no_organizers_label)
	else:
		for organizer: Player in organizers:
			var organizer_panel: EventOrganizerPanel = EventOrganizerPanelScene.instantiate()
			organizers_container.add_child(organizer_panel)
			organizer_panel.populate(organizer)
			if Globals.organizer_mode_enabled:
				organizer_panel.show_delete_button()
				organizer_panel.delete_pressed.connect(_remove_organizer.bind(organizer))


func _go_to_update_event_data_screen() -> void:
	App.change_screen(UPDATE_EVENT_DATA_SCREEN_PATH)


func _go_to_add_organizer_screen() -> void:
	App.change_screen(ADD_ORGANIZER_SCREEN_PATH)


func _remove_organizer(organizer: Player) -> void:
	App.show_loading_sign("Removing organizer...")
	
	await EventsRouter.remove_organizer_from_event(Globals.current_event.id, organizer.id)
	
	App.hide_loading_sign()
	
	if HTTPRequests.failed():
		await App.show_error_dialog("Error removing organizer.")
		return
	
	await App.show_dialog("Organizer removed successfully!")
	
	await _populate_organizers()
	
	
