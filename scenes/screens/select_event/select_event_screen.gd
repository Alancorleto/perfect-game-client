extends Control

@onready var events_container: VBoxContainer = %EventsContainer
@onready var country_option_button: OptionButton = %CountryOptionButton
@onready var include_upcoming_check_box: CheckBox = %IncludeUpcomingCheckBox
@onready var create_tournament_button: Button = %CreateTournamentButton

const LOGIN_SCREEN_SCENE_PATH: String = "res://scenes/screens/user_account/login_screen.tscn"

const EventPanelScene: PackedScene = preload("res://scenes/screens/select_event/event_panel.tscn")


func _ready() -> void:
	App.show_loading_sign("Loading events...")
	
	_show_options()

	var response := await _list_events()
	if response == null:
		App.hide_loading_sign()
		return

	for event: Event in response.events:
		var event_panel: EventPanel = EventPanelScene.instantiate()
		events_container.add_child(event_panel)
		event_panel.populate(event)

	App.hide_loading_sign()


func _show_options() -> void:
	if Globals.organizer_mode_enabled:
		create_tournament_button.show()
		include_upcoming_check_box.hide()
		country_option_button.hide()
	else:
		create_tournament_button.hide()
		include_upcoming_check_box.show()
		country_option_button.show()


func _list_events() -> ListEventsResponse:
	var organized_by: String = ""
	var country_code: String = ""
	var include_upcoming: bool = include_upcoming_check_box.button_pressed
	
	if Globals.organizer_mode_enabled:
		organized_by = Globals.current_user.id
		include_upcoming = true
	
	if country_option_button.selected != 0:
		country_code = country_option_button.text
	
	var response := await EventsRouter.list_events(
		0,
		20,
		country_code,
		organized_by,
		include_upcoming
	)
	
	return response
