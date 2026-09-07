extends GuestPlayerScreenBase


func _submit_form() -> bool:
	var guest_player_create := GuestPlayerCreate.new()
	
	guest_player_create.nickname = nickname_line_edit.text
	guest_player_create.country_code = country_line_edit.text
	
	var player: Player = await TournamentsRouter.create_guest_player(
		Globals.current_tournament.id,
		guest_player_create,
	)
	
	if not player:
		return false
	
	return true
