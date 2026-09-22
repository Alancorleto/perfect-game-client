extends Control

@onready var players_container: VBoxContainer = %PlayersContainer
@onready var add_players_button: Button = $MarginContainer/ScrollContainer/VBoxContainer/PlayersPanel/AddPlayersButton

const PlayerPanelScene := preload("res://scenes/ui_elements/player_panel.tscn")
const ADD_PLAYERS_TO_ROUND_SCREEN_PATH: String = "res://scenes/screens/round/players/add_players_to_round_screen.tscn"


func _ready() -> void:
	add_players_button.pressed.connect(_go_to_add_players_to_round_screen)
	
	var score_table: ScoreTable = Globals.current_score_table
	
	var players: Array[Player] = await ScoreTablesRouter.list_players_in_score_table(score_table.id)
	
	for player: Player in players:
		var player_panel: PlayerPanel = PlayerPanelScene.instantiate()
		players_container.add_child(player_panel)
		player_panel.populate(player)


func _go_to_add_players_to_round_screen() -> void:
	App.change_screen(ADD_PLAYERS_TO_ROUND_SCREEN_PATH)
