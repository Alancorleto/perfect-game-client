extends Control

@onready var create_profile_button: Button = %CreateProfileButton
@onready var edit_profile_button: Button = %EditProfileButton
@onready var view_tournaments_button: Button = %ViewTournamentsButton
@onready var organize_tournaments_button: Button = %OrganizeTournamentsButton
@onready var log_in_button: Button = %LogInButton
@onready var log_out_button: Button = %LogOutButton

const LOGIN_SCREEN_PATH := "res://scenes/screens/user_account/login_screen.tscn"
const SELECT_EVENT_SCREEN_PATH := "res://scenes/screens/select_event/select_event_screen.tscn"
const CREATE_PLAYER_SCREEN_PATH := "res://scenes/screens/player/create_player_screen.tscn"
const UPDATE_PLAYER_SCREEN_PATH := "res://scenes/screens/player/update_player_screen.tscn"


func _ready() -> void:
	create_profile_button.pressed.connect(_go_to_create_player_screen)
	edit_profile_button.pressed.connect(_go_to_update_player_screen)
	view_tournaments_button.pressed.connect(_go_to_select_event_screen_as_spectator)
	organize_tournaments_button.pressed.connect(_go_to_select_event_screen_as_organizer)
	log_in_button.pressed.connect(_go_to_login_screen)
	log_out_button.pressed.connect(_log_out)
	
	Globals.organizer_mode_enabled = false
	
	App.show_loading_sign("Trying automatic log in...")
	
	await _try_refresh_access_token()
	
	App.hide_loading_sign()
	
	if Globals.is_logged_in():
		log_in_button.hide()
		log_out_button.show()
		organize_tournaments_button.show()
		if Globals.current_player != null:
			create_profile_button.hide()
			edit_profile_button.show()
		else:
			create_profile_button.show()
			edit_profile_button.hide()
	else:
		log_in_button.show()
		log_out_button.hide()
		organize_tournaments_button.hide()
		create_profile_button.hide()
		edit_profile_button.hide()


func _go_to_create_player_screen() -> void:
	App.change_screen(CREATE_PLAYER_SCREEN_PATH)


func _go_to_update_player_screen() -> void:
	App.change_screen(UPDATE_PLAYER_SCREEN_PATH)


func _go_to_select_event_screen_as_spectator() -> void:
	Globals.organizer_mode_enabled = false
	App.change_screen(SELECT_EVENT_SCREEN_PATH)


func _go_to_select_event_screen_as_organizer() -> void:
	Globals.organizer_mode_enabled = true
	App.change_screen(SELECT_EVENT_SCREEN_PATH)


func _go_to_login_screen() -> void:
	App.change_screen(LOGIN_SCREEN_PATH)


func _try_refresh_access_token() -> void:
	var refresh_token: String = ""
	
	var config = ConfigFile.new()
	var error: Error = config.load("user://config.cfg")
	if error == OK:
		refresh_token = config.get_value("user", "refresh_token", "")
	
	if refresh_token:
		var token: Token = await UsersRouter.refresh_access_token(refresh_token)
		if token:
			Globals.current_user = await UsersRouter.get_currently_logged_user()
			Globals.current_player = await PlayersRouter.get_currently_logged_player()
			await Globals.current_player.try_load_profile_picture()


func _log_out() -> void:
	_clear_refresh_token()
	_go_to_login_screen()


func _clear_refresh_token() -> void:
	var config = ConfigFile.new()
	var error: Error = config.load("user://config.cfg")
	if error == OK:
		config.set_value("user", "refresh_token", "")
		config.save("user://config.cfg")
