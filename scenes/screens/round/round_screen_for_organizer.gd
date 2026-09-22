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
@onready var score_table_warning_label: Label = %ScoreTableWarningLabel
@onready var create_score_table_button: Button = %CreateScoreTableButton

const UPDATE_ROUND_DATA_SCREEN_PATH: String = "res://scenes/screens/round/update_round_data_screen.tscn"


func _ready() -> void:
	edit_data_button.pressed.connect(_go_to_update_round_data_screen)
	create_score_table_button.pressed.connect(_create_score_table)
	
	App.show_loading_sign("Loading...")
	
	var round: Round = Globals.current_round
	
	_populate_round_data(round)
	
	var score_tables: Array[ScoreTable] = (
		await RoundsRouter.list_score_tables_in_round(round.id)
	)
	
	if round.format == RoundFormat.SCORE_SUM and score_tables.is_empty():
		score_table_warning_label.show()
		create_score_table_button.show()
		manage_charts_button.hide()
		manage_players_button.hide()
		manage_scores_button.hide()
	
	App.hide_loading_sign()


func _populate_round_data(round: Round) -> void:
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


func _create_score_table() -> void:
	App.show_loading_sign("Creating score table...")
	
	var score_table_create := ScoreTableCreate.new()
	
	score_table_create.round_id = Globals.current_round.id
	
	var score_table: ScoreTable = await ScoreTablesRouter.create_score_table(
		score_table_create
	)
	
	App.hide_loading_sign()
	
	if score_table == null:
		await App.show_error_dialog("Error while creating score table.")
		return
	
	await App.show_dialog("Score table created successfully!")
	
	App.change_screen(scene_file_path)


func _go_to_update_round_data_screen() -> void:
	App.change_screen(UPDATE_ROUND_DATA_SCREEN_PATH)
