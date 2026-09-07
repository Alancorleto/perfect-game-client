class_name GuestPlayerScreenBase
extends Control

@export var in_progress_message: String
@export var success_message: String
@export var failure_message: String
@export_file_path("*.tscn") var next_screen_path: String = ""

@onready var nickname_line_edit: LineEdit = %NicknameLineEdit
@onready var country_line_edit: LineEdit = %CountryLineEdit
@onready var has_paid_check_box: CheckBox = %HasPaidCheckBox

@onready var confirm_button: Button = %ConfirmButton

@onready var remove_button: Button = %RemoveButton


func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	remove_button.pressed.connect(_on_remove_button_pressed)
	
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
		App.change_screen(next_screen_path)
	else:
		await App.show_error_dialog(failure_message)


func _on_remove_button_pressed() -> void:
	App.show_loading_sign("Removing player from tournament...")
	
	var players_in_tournament: Array[PlayerInTournament] = await TournamentsRouter.remove_player_from_tournament(
		Globals.current_tournament.id,
		Globals.current_player_in_tournament.player.id,
	)
	
	App.hide_loading_sign()
	
	for player_in_tournament: PlayerInTournament in players_in_tournament:
		if player_in_tournament.player.id == Globals.current_player_in_tournament.player.id:
			await App.show_error_dialog("Error removing player from tournament.")
			return
	
	await App.show_dialog("Player removed successfully!")
	
	App.change_screen(next_screen_path)
