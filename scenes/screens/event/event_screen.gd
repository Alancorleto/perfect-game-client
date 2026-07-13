extends Control

@onready var logo: TextureRect = %Logo
@onready var name_label: Label = %NameLabel
@onready var date_label: Label = %DateLabel
@onready var location_label: Label = %LocationLabel
@onready var description_label: Label = %DescriptionLabel

@onready var tournaments_container: VBoxContainer = %TournamentsContainer
@onready var new_tournament_button: Button = %NewTournamentButton

@onready var organizers_container: VBoxContainer = %OrganizersContainer
@onready var new_organizer_button: Button = %NewOrganizerButton

var event: Event

const TournamentPanelScene := preload("res://scenes/screens/event/tournament_panel.tscn")
const EventOrganizerPanelScene := preload("res://scenes/screens/event/event_organizer_panel.tscn")


func _ready() -> void:
	App.show_loading_sign("Loading event...")

	event = Globals.current_event

	await _populate_tournaments()

	await _populate_organizers()

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
