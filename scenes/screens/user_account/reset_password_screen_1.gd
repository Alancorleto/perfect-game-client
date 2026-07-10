extends Control

@onready var email_field: LineEdit = %EmailField
@onready var confirm_button: Button = %ConfirmButton

const RESET_PASSWORD_SCREEN_2_SCENE_PATH: String = "res://scenes/screens/user_account/reset_password_screen_2.tscn"


func _ready() -> void:
	confirm_button.pressed.connect(_request_password_reset)


func _request_password_reset() -> void:
	var email: String = email_field.text
	if email == "":
		App.show_error_dialog("Email cannot be empty")
		return

	App.show_loading_sign("Requesting password reset...")

	var password_reset_request := PasswordResetRequest.new({
		"email": email,
	})

	var response: Dictionary = await UsersRouter.request_password_reset(password_reset_request)

	App.hide_loading_sign()

	if response == null:
		App.show_error_dialog("Failed to request password reset")
		return

	await App.show_dialog("Password reset request sent. Please check your email for the reset code.")

	Globals.recovery_email = email

	App.change_screen(RESET_PASSWORD_SCREEN_2_SCENE_PATH)
