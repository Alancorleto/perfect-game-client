extends TournamentDataScreenBase


func _populate() -> void:
	name_line_edit.text = Globals.current_tournament.name
	auto_accept_check_box.button_pressed = Globals.current_tournament.auto_accept_join_requests


func _submit_form() -> bool:
	var tournament_update := TournamentUpdate.new()
	
	tournament_update.name = name_line_edit.text
	tournament_update.auto_accept_join_requests = auto_accept_check_box.button_pressed
	
	var tournament: Tournament = await TournamentsRouter.update_tournament(
		Globals.current_tournament.id,
		tournament_update,
	)
	
	if not tournament:
		return false
	
	Globals.current_tournament = tournament
	
	return true
