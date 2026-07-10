class_name CreateAccountScreen
extends Control

@onready var email_field: LineEdit = %EmailField
@onready var email_field_2: LineEdit = %EmailField2
@onready var password_field: LineEdit = %PasswordField
@onready var password_field_2: LineEdit = %PasswordField2
@onready var create_account_button: Button = %CreateAccountButton

const LOGIN_SCREEN_PATH: String = "res://scenes/screens/user_account/login_screen.tscn"


func _ready() -> void:
	create_account_button.pressed.connect(_try_create_account)


func _try_create_account() -> void:
	if email_field.text != email_field_2.text:
		App.show_error_dialog("Emails do not match")
		return
	if password_field.text != password_field_2.text:
		App.show_error_dialog("Passwords do not match")
		return
	if email_field.text == "" or password_field.text == "":
		App.show_error_dialog("Email and password cannot be empty")
		return

	App.show_loading_sign("Creating account...")

	var user_create := UserCreate.new({
		"email": email_field.text,
		"password": password_field.text
	})

	var user: UserResponse = await UsersRouter.create_user(user_create)

	App.hide_loading_sign()

	if user == null:
		App.hide_loading_sign()
		App.show_error_dialog("Failed to create account")
		return

	await App.show_dialog("Account created successfully. You can now log in.")

	App.change_screen(LOGIN_SCREEN_PATH)
