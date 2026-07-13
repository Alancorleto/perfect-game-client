extends Control

@onready var name_label: Label = %NameLabel
@onready var rounds_container: VBoxContainer = %RoundsContainer
@onready var players_container: VBoxContainer = %PlayersContainer

var tournament: Tournament

const TournamentPlayerPanelScene := preload("res://scenes/screens/tournament/tournament_player_panel.tscn")
const RoundPanelScene := preload("res://scenes/screens/tournament/round_panel.tscn")


func _ready() -> void:
	App.show_loading_sign("Loading rounds...")

	tournament = Globals.current_tournament

	name_label.text = tournament.name

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
