extends GuestPlayerScreenBase


func _submit_form() -> bool:
	# Guest player creation
	
	var guest_player_create := GuestPlayerCreate.new()
	
	guest_player_create.nickname = nickname_line_edit.text
	guest_player_create.country_code = country_line_edit.text
	
	var player: Player = await TournamentsRouter.create_guest_player(
		Globals.current_tournament.id,
		guest_player_create,
	)
	
	if not player:
		return false
	
	# Has paid
	
	var player_in_tournament_update := PlayerInTournamentUpdate.new()
	player_in_tournament_update.has_paid_entry = has_paid_check_box.button_pressed
	
	var update_player_in_tournament: PlayerInTournament = (
		await TournamentsRouter.update_player_in_tournament(
			Globals.current_tournament.id,
			player.id,
			player_in_tournament_update,
		)
	)
	
	if not update_player_in_tournament:
		return false
	
	return true
