extends Control

@onready var name_label: Label = %NameLabel
@onready var rounds_container: VBoxContainer = %RoundsContainer
@onready var players_container: VBoxContainer = %PlayersContainer

var tournament: Tournament

const TournamentPlayerPanelScene := preload("res://scenes/screens/tournament/tournament_player_panel.tscn")


func _ready() -> void:
	tournament = Globals.current_tournament

	name_label.text = tournament.name

	# await _populate_rounds()

	await _populate_players()


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
