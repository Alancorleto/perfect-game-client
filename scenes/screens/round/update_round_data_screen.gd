extends RoundDataScreenBase

var format_indexes: Array[String] = [
	RoundFormat.SCORE_SUM,
	RoundFormat.BATTLE,
]


func _populate() -> void:
	var round: Round = Globals.current_round
	
	name_line_edit.placeholder_text = round.get_default_name()
	
	if round.name != null:
		name_line_edit.text = round.name
	
	format_option_button.select(format_indexes.find(round.format))
	
	if round.levels != null:
		levels_line_edit.text = round.levels
	
	if round.qualifiers_count != null:
		qualifiers_count_line_edit.text = str(int(round.qualifiers_count))


func _submit_form() -> bool:
	var round_update := RoundUpdate.new()
	
	if name_line_edit.text:
		round_update.name = name_line_edit.text
	round_update.format = format_option_button.text.to_snake_case()
	if levels_line_edit.text:
		round_update.levels = levels_line_edit.text
	if qualifiers_count_line_edit.text:
		round_update.qualifiers_count = int(qualifiers_count_line_edit.text)
	
	var new_round: Round = await RoundsRouter.update_round(
		Globals.current_round.id,
		round_update,
	)
	
	if not new_round:
		return false
	
	Globals.current_round = new_round
	
	return true
