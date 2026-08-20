extends Control

@onready var view_tournaments_button: Button = $MarginContainer/HBoxContainer/ViewTournamentsButton
@onready var organize_tournaments_button: Button = $MarginContainer/HBoxContainer/OrganizeTournamentsButton
@onready var log_in_button: Button = $MarginContainer/HBoxContainer/LogInButton

const LOGIN_SCREEN_PATH := "res://scenes/screens/user_account/login_screen.tscn"
const SELECT_EVENT_SCREEN_PATH := "res://scenes/screens/select_event/select_event_screen.tscn"


func _ready() -> void:
	view_tournaments_button.pressed.connect(_go_to_select_event_screen_as_spectator)
	organize_tournaments_button.pressed.connect(_go_to_select_event_screen_as_organizer)
	log_in_button.pressed.connect(_go_to_login_screen)
	
	Globals.organizer_mode_enabled = false
	
	if not Globals.is_logged_in():
		log_in_button.show()
		organize_tournaments_button.hide()
	else:
		log_in_button.hide()
		organize_tournaments_button.show()


func _go_to_select_event_screen_as_spectator() -> void:
	Globals.organizer_mode_enabled = false
	App.change_screen(SELECT_EVENT_SCREEN_PATH)


func _go_to_select_event_screen_as_organizer() -> void:
	Globals.organizer_mode_enabled = true
	App.change_screen(SELECT_EVENT_SCREEN_PATH)


func _go_to_login_screen() -> void:
	App.change_screen(LOGIN_SCREEN_PATH)
