extends Control

@onready var name_label: Label = %NameLabel
@onready var format_label: Label = %FormatLabel
@onready var levels_label: Label = %LevelsLabel
@onready var qualifiers_count_label: Label = %QualifiersCountLabel
@onready var state_label: Label = %StateLabel


func _ready() -> void:
	var round: Round = Globals.current_round
	
	name_label.text = round.get_display_name()
	
	format_label.text = "Format: " + round.format.capitalize()
	
	if round.levels != null:
		levels_label.text = "Levels: " + round.levels
	else:
		levels_label.text = "Levels: Not specified"
	
	if round.qualifiers_count != null:
		qualifiers_count_label.text = "Qualifiers Count: " + str(round.qualifiers_count)
	else:
		qualifiers_count_label.text = "All players qualify"
	
	state_label.text = "State: " + round.state.capitalize()
