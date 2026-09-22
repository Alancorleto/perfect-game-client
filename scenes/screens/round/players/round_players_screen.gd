extends Control

@onready var players_container: VBoxContainer = %PlayersContainer
@onready var add_players_button: Button = %AddPlayersButton
@onready var change_order_button: Button = %ChangeOrderButton
@onready var confirm_order_change_button: Button = %ConfirmOrderChangeButton

const PlayerPanelScene := preload("res://scenes/ui_elements/player_panel.tscn")
const ADD_PLAYERS_TO_ROUND_SCREEN_PATH: String = "res://scenes/screens/round/players/add_players_to_round_screen.tscn"

var currently_dragged_player_panel: PlayerPanel


func _ready() -> void:
	add_players_button.pressed.connect(_go_to_add_players_to_round_screen)
	change_order_button.pressed.connect(_enable_change_order_mode)
	confirm_order_change_button.pressed.connect(_change_player_order)
	
	var score_table: ScoreTable = Globals.current_score_table
	
	var players: Array[Player] = await ScoreTablesRouter.list_players_in_score_table(score_table.id)
	
	for player: Player in players:
		var player_panel: PlayerPanel = PlayerPanelScene.instantiate()
		players_container.add_child(player_panel)
		
		player_panel.populate(player)
		
		player_panel.button.mouse_entered.connect(_on_player_panel_mouse_entered.bind(player_panel))
		player_panel.move_button_down.connect(_start_dragging_player_panel.bind(player_panel))
		player_panel.move_button_up.connect(_stop_dragging_player_panel.bind(player_panel))
	
	if players.is_empty():
		change_order_button.hide()


func _enable_change_order_mode() -> void:
	for player_panel: PlayerPanel in players_container.get_children():
		player_panel.show_move_button()
	change_order_button.hide()
	confirm_order_change_button.show()
	add_players_button.hide()


func _change_player_order() -> void:
	App.show_loading_sign("Changing player order...")
	
	var new_player_id_order: Array[String] = []
	
	for player_panel: PlayerPanel in players_container.get_children():
		new_player_id_order.append(player_panel.player.id)
	
	var new_players: Array[Player] = await ScoreTablesRouter.update_player_order_in_score_table(
		Globals.current_score_table.id,
		new_player_id_order,
	)
	
	App.hide_loading_sign()
	
	if not new_players:
		await App.show_error_dialog("Error changing players order")
		return
	
	await App.show_dialog("Player order changed successfully!")
	
	App.change_screen(scene_file_path)


func _go_to_add_players_to_round_screen() -> void:
	App.change_screen(ADD_PLAYERS_TO_ROUND_SCREEN_PATH)


func _start_dragging_player_panel(player_panel: PlayerPanel) -> void:
	currently_dragged_player_panel = player_panel


func _stop_dragging_player_panel(player_panel: PlayerPanel) -> void:
	if currently_dragged_player_panel == player_panel:
		currently_dragged_player_panel = null


func _on_player_panel_mouse_entered(player_panel: PlayerPanel) -> void:
	if currently_dragged_player_panel != null:
		players_container.move_child(player_panel, currently_dragged_player_panel.get_index())
