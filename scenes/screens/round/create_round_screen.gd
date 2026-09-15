extends RoundDataScreenBase

func _submit_form() -> bool:
	var round_create := RoundCreate.new()
	
	round_create.name = name_line_edit.text
	round_create.format = format_option_button.text.to_snake_case()
	round_create.levels = levels_line_edit.text
	round_create.qualifiers_count = int(qualifiers_count_line_edit.text)
	
	round_create.tournament_id = Globals.current_tournament.id
	
	var new_round: Round = await RoundsRouter.create_round(round_create)
	
	if not new_round:
		return false
	
	return true
