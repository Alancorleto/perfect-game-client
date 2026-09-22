extends Control

@onready var players_container: VBoxContainer = %PlayersContainer
@onready var select_all_button: Button = %SelectAllButton
@onready var select_none_button: Button = %SelectNoneButton
@onready var confirm_button: Button = %ConfirmButton

const PlayerPanelScene := preload("res://scenes/ui_elements/player_panel.tscn")
const ROUND_PLAYERS_SCREEN_PATH: String = "res://scenes/screens/round/players/round_players_screen.tscn"

func _ready() -> void:
	select_all_button.pressed.connect(_select_all)
	select_none_button.pressed.connect(_select_none)
	confirm_button.pressed.connect(_add_players_to_round)
	
	var players_in_tournament: Array[PlayerInTournament] = await TournamentsRouter.list_players_in_tournament(Globals.current_tournament.id)
	
	for player_in_tournament: PlayerInTournament in players_in_tournament:
		var player_panel: PlayerPanel = PlayerPanelScene.instantiate()
		players_container.add_child(player_panel)
		
		player_panel.enable_toggle_mode()
		player_panel.populate(player_in_tournament.player)


func _select_all() -> void:
	for player_panel: PlayerPanel in players_container.get_children():
		player_panel.toggle(true)


func _select_none() -> void:
	for player_panel: PlayerPanel in players_container.get_children():
		player_panel.toggle(false)


func _add_players_to_round() -> void:
	App.show_loading_sign("Adding players...")
	
	var player_ids_to_add: Array[String] = []
	
	for player_panel: PlayerPanel in players_container.get_children():
		if player_panel.is_pressed():
			player_ids_to_add.append(player_panel.player.id)
	
	var players: Array[Player] = await ScoreTablesRouter.bulk_add_players_to_score_table(
		Globals.current_score_table.id,
		player_ids_to_add,
	)
	
	App.hide_loading_sign()
	
	if not players:
		await App.show_error_dialog("Error while adding players")
		return
	
	await App.show_dialog("Players added successfully!")
	
	App.change_screen(ROUND_PLAYERS_SCREEN_PATH)
