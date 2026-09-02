class_name TournamentDataScreenBase
extends Control

@export var in_progress_message: String
@export var success_message: String
@export var failure_message: String

@onready var name_line_edit: LineEdit = %NameLineEdit
@onready var auto_accept_check_box: CheckBox = %AutoAcceptCheckBox
@onready var confirm_button: Button = %ConfirmButton

const TOURNAMENT_SCREEN_PATH := "res://scenes/screens/tournament/tournament_screen.tscn"


func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	
	_populate()


func _submit_form() -> bool:
	await get_tree().process_frame
	return true


func _populate() -> void:
	pass


func _on_confirm_button_pressed() -> void:
	App.show_loading_sign(in_progress_message)
	
	var success: bool = await _submit_form()
	
	App.hide_loading_sign()
	if success:
		await App.show_dialog(success_message)
		App.change_screen(TOURNAMENT_SCREEN_PATH)
	else:
		await App.show_error_dialog(failure_message)
