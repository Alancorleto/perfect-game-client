class_name TournamentPlayerPanel
extends PanelContainer

signal pressed(player_in_tournament: PlayerInTournament)

@onready var button: Button = %Button
@onready var name_panel: Label = %NamePanel
@onready var paid_check_button: Button = %PaidCheckButton
@onready var delete_button: TextureButton = %DeleteButton


func populate(player_in_tournament: PlayerInTournament) -> void:
	name_panel.text = player_in_tournament.player.nickname
	button.pressed.connect(_notify_pressed.bind(player_in_tournament))


func _notify_pressed(player_in_tournament: PlayerInTournament) -> void:
	pressed.emit(player_in_tournament)
