extends Control

@onready var name_label: Label = %NameLabel
@onready var format_label: Label = %FormatLabel
@onready var levels_label: Label = %LevelsLabel
@onready var qualifiers_count_label: Label = %QualifiersCountLabel
@onready var state_label: Label = %StateLabel

@onready var edit_data_button: Button = %EditDataButton
@onready var manage_charts_button: Button = %ManageChartsButton
@onready var manage_players_button: Button = %ManagePlayersButton
@onready var manage_scores_button: Button = %ManageScoresButton

const UPDATE_ROUND_DATA_SCREEN_PATH: String = "res://scenes/screens/round/update_round_data_screen.tscn"


func _ready() -> void:
	edit_data_button.pressed.connect(_go_to_update_round_data_screen)
	
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


func _go_to_update_round_data_screen() -> void:
	App.change_screen(UPDATE_ROUND_DATA_SCREEN_PATH)
