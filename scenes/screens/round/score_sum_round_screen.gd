class_name ScoreSumRoundScreen
extends Control

@onready var score_column_panels_container: Control = %ScoreColumnPanelsContainer
@onready var previous_column_button: Button = %PreviousColumnButton
@onready var next_column_button: Button = %NextColumnButton
@onready var column_description_label: Label = %ColumnDescriptionLabel

const ScoreColumnPanelScene := preload("res://scenes/screens/round/score_column_panel.tscn")

var round: Round
var score_table: ScoreTable
var current_column_panel: ScoreColumnPanel


func _ready() -> void:
	previous_column_button.pressed.connect(_show_previous_column)
	next_column_button.pressed.connect(_show_next_column)

	App.show_loading_sign("Loading rounds...")

	await _populate_round()

	App.hide_loading_sign()


func _populate_round() -> void:
	round = Globals.current_round

	score_table = await _get_first_score_table()

	var results: Results = await ScoreTablesRouter.get_score_table_results(score_table.id)

	_populate_total_column(results)

	for column_results: ColumnResults in results.columns_results:
		_populate_column(column_results, results.player_standings)


func _get_first_score_table() -> ScoreTable:
	var score_tables: Array[ScoreTable] = await RoundsRouter.list_score_tables_in_round(round.id)
	if score_tables.size() == 0:
		return null
	return score_tables[0]


func _populate_total_column(results: Results) -> void:
	var total_results_column_panel: ScoreColumnPanel = ScoreColumnPanelScene.instantiate()
	score_column_panels_container.add_child(total_results_column_panel)
	total_results_column_panel.populate_total(results.total_results, results.player_standings)
	current_column_panel = total_results_column_panel


func _populate_column(column_results: ColumnResults, player_standings: Array[PlayerStanding]) -> void:
	var score_column_panel: ScoreColumnPanel = ScoreColumnPanelScene.instantiate()
	score_column_panels_container.add_child(score_column_panel)
	score_column_panel.populate(column_results, player_standings)
	score_column_panel.hide()


func _show_previous_column() -> void:
	_cycle_column(-1)

func _show_next_column() -> void:
	_cycle_column(1)


func _cycle_column(direction: int) -> void:
	if current_column_panel == null:
		return
	current_column_panel.hide()

	var new_index: int = current_column_panel.get_index() + direction

	if new_index < 0:
		new_index = score_column_panels_container.get_child_count() - 1
	if new_index >= score_column_panels_container.get_child_count():
		new_index = 0

	var new_panel: ScoreColumnPanel = score_column_panels_container.get_child(new_index)

	new_panel.show()

	current_column_panel = new_panel
	
	column_description_label.text = current_column_panel.description
