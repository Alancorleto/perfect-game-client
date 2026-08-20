extends Control

@onready var events_container: VBoxContainer = %EventsContainer
@onready var log_in_button: Button = %LogInButton
@onready var country_option_button: OptionButton = %CountryOptionButton
@onready var organized_by_me_check_box: CheckBox = %OrganizedByMeCheckBox
@onready var include_upcoming_check_box: CheckBox = %IncludeUpcomingCheckBox
@onready var create_tournament_button: Button = %CreateTournamentButton

const LOGIN_SCREEN_SCENE_PATH: String = "res://scenes/screens/user_account/login_screen.tscn"

const EventPanelScene: PackedScene = preload("res://scenes/screens/select_event/event_panel.tscn")


func _ready() -> void:
	log_in_button.pressed.connect(App.change_screen.bind(LOGIN_SCREEN_SCENE_PATH))
	
	App.show_loading_sign("Loading events...")
	
	_show_options()

	var response := await EventsRouter.list_events()
	if response == null:
		App.hide_loading_sign()
		return

	for event: Event in response.events:
		var event_panel: EventPanel = EventPanelScene.instantiate()
		events_container.add_child(event_panel)
		event_panel.populate(event)

	App.hide_loading_sign()


func _show_options() -> void:
	if Globals.is_logged_in():
		log_in_button.hide()
		organized_by_me_check_box.show()
		create_tournament_button.show()
	else:
		log_in_button.show()
		organized_by_me_check_box.hide()
		create_tournament_button.hide()
