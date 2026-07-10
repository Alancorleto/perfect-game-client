class_name LoginScreen
extends Control

@onready var email_field: LineEdit = %EmailField
@onready var password_field: LineEdit = %PasswordField
@onready var login_button: Button = %LoginButton

const SELECT_MODE_SCREEN_PATH: String = "res://scenes/placeholder/screens/select_mode_screen.tscn"


func _ready() -> void:
	login_button.pressed.connect(_on_login_button_pressed)


func _login() -> void:
	App.show_loading_sign("Logging in...")
	
	var email: String = email_field.text
	var password: String = password_field.text
	var token: Token = await UsersRouter.login(email, password)
	
	App.hide_loading_sign()
	
	if token == null:
		App.show_loading_sign("Failed to log in.")
		return
	
	App.change_screen(SELECT_MODE_SCREEN_PATH)


func _on_login_button_pressed() -> void:
	_login()
