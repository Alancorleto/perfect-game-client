extends GuestPlayerScreenBase


func _populate() -> void:
	var player_in_tournament: PlayerInTournament = Globals.current_player_in_tournament
	var player: Player = player_in_tournament.player
	
	nickname_line_edit.text = player.nickname
	country_line_edit.text = player.country_code
	has_paid_check_box.button_pressed = player_in_tournament.has_paid_entry
	
	if not _is_guest_player():
		nickname_line_edit.editable = false
		country_line_edit.editable = false


func _submit_form() -> bool:
	var player_in_tournament: PlayerInTournament = Globals.current_player_in_tournament
	var player: Player = player_in_tournament.player
	
	if _is_guest_player():
		var player_update := PlayerUpdate.new()
		
		player_update.nickname = nickname_line_edit.text
		player_update.country_code = country_line_edit.text
	
		var updated_player: Player = await PlayersRouter.update_player(
			player.id,
			player_update,
		)
		
		if not updated_player:
			return false
	
	var player_in_tournament_update := PlayerInTournamentUpdate.new()
	
	player_in_tournament_update.has_paid_entry = has_paid_check_box.button_pressed
	
	var updated_player_in_tournament := await TournamentsRouter.update_player_in_tournament(
		Globals.current_tournament.id,
		player.id,
		player_in_tournament_update,
	)
	
	if not updated_player_in_tournament:
		return false
	
	return true


func _is_guest_player() -> bool:
	return Globals.current_player_in_tournament.player.guest_tournament_id == Globals.current_tournament.id
