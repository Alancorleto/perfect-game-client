extends Control

@onready var password_field: LineEdit = %PasswordField
@onready var password_field_2: LineEdit = %PasswordField2
@onready var confirm_button: Button = %ConfirmButton

const LOGIN_SCREEN_SCENE_PATH: String = "res://scenes/screens/user_account/login_screen.tscn"


func _ready() -> void:
	confirm_button.pressed.connect(_confirm_password_reset)


func _confirm_password_reset() -> void:
	var password: String = password_field.text
	var password_2: String = password_field_2.text

	if password == "" or password_2 == "":
		App.show_error_dialog("Password fields cannot be empty")
		return

	if password != password_2:
		App.show_error_dialog("Passwords do not match")
		return

	App.show_loading_sign("Resetting password...")

	var email: String = Globals.recovery_email
	var recovery_code: String = Globals.recovery_code

	var password_reset_confirm := PasswordResetConfirm.new({
		"email": email,
		"code": recovery_code,
		"new_password": password,
	})
	var response: Dictionary = await UsersRouter.confirm_password_reset(password_reset_confirm)

	App.hide_loading_sign()

	if response == {}:
		App.show_error_dialog("Failed to reset password")
		return

	await App.show_dialog("Password reset successful. You can now log in with your new password.")

	App.change_screen(LOGIN_SCREEN_SCENE_PATH)
