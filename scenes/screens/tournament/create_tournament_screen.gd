extends TournamentDataScreenBase


func _submit_form() -> bool:
	var tournament_create := TournamentCreate.new()
	
	tournament_create.name = name_line_edit.text
	tournament_create.auto_accept_join_requests = auto_accept_check_box.button_pressed
	
	tournament_create.event_id = Globals.current_event.id
	
	var tournament: Tournament = await TournamentsRouter.create_tournament(tournament_create)
	
	if not tournament:
		return false
	
	Globals.current_tournament = tournament
	
	return true
