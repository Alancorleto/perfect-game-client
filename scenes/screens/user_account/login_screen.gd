class_name LoginScreen
extends Control

@onready var login_button: Button = %LoginButton

const SELECT_MODE_SCREEN_PATH: String = "res://scenes/placeholder/screens/select_mode_screen.tscn"

func _ready() -> void:
	login_button.pressed.connect(_on_login_button_pressed)


func _on_login_button_pressed() -> void:
	App.show_loading_sign("Logging in...")
	await get_tree().create_timer(2.0).timeout
	App.hide_loading_sign()
	App.change_screen(SELECT_MODE_SCREEN_PATH)
