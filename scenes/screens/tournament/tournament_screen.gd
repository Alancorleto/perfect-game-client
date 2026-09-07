extends Control

@onready var name_label: Label = %NameLabel
@onready var rounds_container: VBoxContainer = %RoundsContainer
@onready var players_container: VBoxContainer = %PlayersContainer
@onready var update_button: Button = %UpdateButton
@onready var add_player_button: Button = %AddPlayerButton

var tournament: Tournament

const TournamentPlayerPanelScene := preload("res://scenes/screens/tournament/tournament_player_panel.tscn")
const RoundPanelScene := preload("res://scenes/screens/tournament/round_panel.tscn")

const UPDATE_TOURNAMENT_DATA_SCREEN_PATH: String = "res://scenes/screens/tournament/update_tournament_data_screen.tscn"
const CREATE_GUEST_PLAYER_SCREEN_PATH: String = "res://scenes/screens/tournament/guest_player/create_guest_player_screen.tscn"
const UPDATE_PLAYER_IN_TOURNAMENT_SCREEN: String = "res://scenes/screens/tournament/guest_player/update_player_in_tournament_screen.tscn"


func _ready() -> void:
	update_button.pressed.connect(_go_to_update_tournament_screen)
	add_player_button.pressed.connect(_go_to_create_guest_player_screen)
	
	App.show_loading_sign("Loading rounds...")

	tournament = Globals.current_tournament

	name_label.text = tournament.name
	
	if Globals.organizer_mode_enabled:
		update_button.show()
		add_player_button.show()
	else:
		update_button.hide()
		add_player_button.hide()

	await _populate_rounds()

	await _populate_players()

	App.hide_loading_sign()


func _populate_rounds() -> void:
	for child in rounds_container.get_children():
		rounds_container.remove_child(child)
		child.queue_free()

	var rounds: Array[Round] = await TournamentsRouter.list_rounds_in_tournament(tournament.id)
	if rounds.is_empty():
		var no_rounds_label: Label = Label.new()
		no_rounds_label.text = "No rounds available."
		rounds_container.add_child(no_rounds_label)
	else:
		for round: Round in rounds:
			var round_panel: RoundPanel = RoundPanelScene.instantiate()
			rounds_container.add_child(round_panel)
			round_panel.populate(round)



func _populate_players() -> void:
	for child in players_container.get_children():
		players_container.remove_child(child)
		child.queue_free()

	var players: Array[PlayerInTournament] = await TournamentsRouter.list_players_in_tournament(tournament.id)
	if players.is_empty():
		var no_players_label: Label = Label.new()
		no_players_label.text = "No players available."
		players_container.add_child(no_players_label)
	else:
		for player: PlayerInTournament in players:
			var player_panel: TournamentPlayerPanel = TournamentPlayerPanelScene.instantiate()
			players_container.add_child(player_panel)
			player_panel.populate(player)
			player_panel.pressed.connect(_go_to_update_player_in_tournament_screen)


func _go_to_update_tournament_screen() -> void:
	App.change_screen(UPDATE_TOURNAMENT_DATA_SCREEN_PATH)


func _go_to_create_guest_player_screen() -> void:
	App.change_screen(CREATE_GUEST_PLAYER_SCREEN_PATH)


func _go_to_update_player_in_tournament_screen(player_in_tournament: PlayerInTournament) -> void:
	Globals.current_player_in_tournament = player_in_tournament
	App.change_screen(UPDATE_PLAYER_IN_TOURNAMENT_SCREEN)
