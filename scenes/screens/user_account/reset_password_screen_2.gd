extends Control

@onready var recovery_code_field: LineEdit = %RecoveryCodeField
@onready var confirm_button: Button = %ConfirmButton

const RESET_PASSWORD_SCREEN_3_SCENE_PATH: String = "res://scenes/screens/user_account/reset_password_screen_3.tscn"


func _ready() -> void:
	confirm_button.pressed.connect(_confirm_recovery_code)


func _confirm_recovery_code() -> void:
	var recovery_code: String = recovery_code_field.text
	if recovery_code == "":
		App.show_error_dialog("Recovery code cannot be empty")
		return

	App.show_loading_sign("Confirming recovery code...")

	var email: String = Globals.recovery_email
	var password_reset_verify := PasswordResetVerify.new({
		"email": email,
		"code": recovery_code,
	})
	var response: Dictionary = await UsersRouter.verify_password_reset_code(password_reset_verify)

	App.hide_loading_sign()

	if response == {}:
		App.show_error_dialog("Failed to confirm recovery code")
		return

	await App.show_dialog("Recovery code confirmed. You can now reset your password.")

	Globals.recovery_code = recovery_code

	App.change_screen(RESET_PASSWORD_SCREEN_3_SCENE_PATH)
