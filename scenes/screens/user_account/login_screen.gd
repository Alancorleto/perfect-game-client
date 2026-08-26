class_name LoginScreen
extends Control

@onready var email_field: LineEdit = %EmailField
@onready var password_field: LineEdit = %PasswordField
@onready var login_button: Button = %LoginButton

@onready var reset_password_button: Button = %ResetPasswordButton
@onready var create_account_button: Button = %CreateAccountButton

const SELECT_MODE_SCREEN_PATH: String = "res://scenes/placeholder/screens/select_mode_screen.tscn"
const CREATE_ACCOUNT_SCREEN_PATH: String = "res://scenes/screens/user_account/create_account_screen.tscn"
const RESET_PASSWORD_SCREEN_PATH: String = "res://scenes/screens/user_account/reset_password_screen_1.tscn"


func _ready() -> void:
	login_button.pressed.connect(_login)
	create_account_button.pressed.connect(_go_to_create_account_screen)
	reset_password_button.pressed.connect(_go_to_reset_password_screen)


func _login() -> void:
	App.show_loading_sign("Logging in...")

	var email: String = email_field.text
	var password: String = password_field.text
	var token: Token = await UsersRouter.login(email, password)
	
	if token == null:
		App.hide_loading_sign()
		await App.show_error_dialog("Failed to log in.")
		return
	
	_save_refresh_token(token)
	
	Globals.current_user = await UsersRouter.get_currently_logged_user()
	
	Globals.current_player = await PlayersRouter.get_currently_logged_player()
	await Globals.current_player.try_load_profile_picture()
	
	App.hide_loading_sign()
	
	App.change_screen(SELECT_MODE_SCREEN_PATH)


func _go_to_create_account_screen() -> void:
	App.change_screen(CREATE_ACCOUNT_SCREEN_PATH)


func _go_to_reset_password_screen() -> void:
	App.change_screen(RESET_PASSWORD_SCREEN_PATH)


func _save_refresh_token(token: Token) -> void:
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	config.set_value("user", "refresh_token", token.refresh_token)
	config.save("user://config.cfg")
