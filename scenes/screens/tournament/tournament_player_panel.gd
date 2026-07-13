class_name TournamentPlayerPanel
extends PanelContainer

@onready var button: Button = %Button
@onready var name_panel: Label = %NamePanel
@onready var paid_check_button: Button = %PaidCheckButton
@onready var delete_button: TextureButton = %DeleteButton


func populate(player_in_tournament: PlayerInTournament) -> void:
	name_panel.text = player_in_tournament.player.nickname
