extends Control

@onready var name_label: Label = %NameLabel
@onready var format_label: Label = %FormatLabel
@onready var levels_label: Label = %LevelsLabel
@onready var qualifiers_count_label: Label = %QualifiersCountLabel
@onready var state_label: Label = %StateLabel

@onready var start_button: Button = %StartButton
@onready var pause_button: Button = %PauseButton
@onready var resume_button: Button = %ResumeButton
@onready var finish_button: Button = %FinishButton

@onready var edit_data_button: Button = %EditDataButton
@onready var manage_charts_button: Button = %ManageChartsButton
@onready var manage_players_button: Button = %ManagePlayersButton
@onready var manage_scores_button: Button = %ManageScoresButton

const UPDATE_ROUND_DATA_SCREEN_PATH: String = "res://scenes/screens/round/update_round_data_screen.tscn"


func _ready() -> void:
	edit_data_button.pressed.connect(_go_to_update_round_data_screen)
	start_button.pressed.connect(_start_round)
	pause_button.pressed.connect(_pause_round)
	resume_button.pressed.connect(_on_resume_button_pressed)
	finish_button.pressed.connect(_finish_round)
	
	var round: Round = Globals.current_round
	
	name_label.text = round.get_display_name()
	
	format_label.text = "Format: " + round.format.capitalize()
	
	if round.levels != null:
		levels_label.text = "Levels: " + round.levels
	else:
		levels_label.text = "Levels: Not specified"
	
	if round.qualifiers_count != null:
		qualifiers_count_label.text = "Qualifiers Count: " + str(int(round.qualifiers_count))
	else:
		qualifiers_count_label.text = "All players qualify"
	
	state_label.text = "State: " + round.state.capitalize()
	
	_update_state_action_buttons()


func _go_to_update_round_data_screen() -> void:
	App.change_screen(UPDATE_ROUND_DATA_SCREEN_PATH)


func _update_state_action_buttons() -> void:
	var round: Round = Globals.current_round
	
	match round.state:
		RoundState.NOT_STARTED:
			start_button.show()
			pause_button.hide()
			resume_button.hide()
			finish_button.hide()
		RoundState.IN_PROGRESS:
			start_button.hide()
			pause_button.show()
			resume_button.hide()
			finish_button.show()
		RoundState.PAUSED:
			start_button.hide()
			pause_button.hide()
			resume_button.show()
			finish_button.hide()
		RoundState.FINISHED:
			start_button.hide()
			pause_button.hide()
			resume_button.show()
			finish_button.hide()


func _start_round() -> void:
	_change_round_state(
		RoundsRouter.start_round,
		"Starting round...",
		"Round started successfully!",
		"Error while starting round."
	)


func _pause_round() -> void:
	_change_round_state(
		RoundsRouter.pause_round,
		"Pausing round...",
		"Round paused successfully!",
		"Error while pausing round."
	)


func _unpause_round() -> void:
	_change_round_state(
		RoundsRouter.unpause_round,
		"Resuming round...",
		"Round resumed successfully!",
		"Error while resuming round."
	)


func _finish_round() -> void:
	_change_round_state(
		RoundsRouter.finish_round,
		"Finishing round...",
		"Round finished successfully!",
		"Error while finishing round."
	)


func _cancel_round_finish() -> void:
	_change_round_state(
		RoundsRouter.cancel_round_finish,
		"Resuming round...",
		"Round resumed successfully!",
		"Error while resuming round."
	)


func _change_round_state(
	endpoint_function: Callable,
	progress_message: String = "",
	success_message: String = "",
	error_message: String = "",
) -> void:
	App.show_loading_sign(progress_message)
	
	var new_round: Round = await endpoint_function.call(Globals.current_round.id)
	
	App.hide_loading_sign()
	
	if new_round == null:
		await App.show_error_dialog(error_message)
		return
	
	await App.show_dialog(success_message)
	
	Globals.current_round = new_round
	
	App.change_screen(scene_file_path)


func _on_resume_button_pressed() -> void:
	match Globals.current_round.state:
		RoundState.PAUSED:
			_unpause_round()
		RoundState.FINISHED:
			_cancel_round_finish()
