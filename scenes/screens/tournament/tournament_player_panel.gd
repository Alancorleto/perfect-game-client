class_name TournamentPlayerPanel
extends PanelContainer

signal pressed(player_in_tournament: PlayerInTournament)

@onready var button: Button = %Button
@onready var name_panel: Label = %NamePanel
@onready var paid_check_button: Button = %PaidCheckButton
@onready var delete_button: TextureButton = %DeleteButton
@onready var has_paid_container: HBoxContainer = %HasPaidContainer


func populate(player_in_tournament: PlayerInTournament) -> void:
	name_panel.text = player_in_tournament.player.nickname
	if Globals.organizer_mode_enabled and player_in_tournament.has_paid_entry:
		has_paid_container.show()
	else:
		has_paid_container.hide()
	button.pressed.connect(_notify_pressed.bind(player_in_tournament))


func _notify_pressed(player_in_tournament: PlayerInTournament) -> void:
	pressed.emit(player_in_tournament)
