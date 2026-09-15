class_name Round
extends Serializable

var id = ""
var tournament_id = ""

var name = null
var levels = null
var format = RoundFormat.SCORE_SUM
var qualifiers_count = null
var state = RoundState.NOT_STARTED
var order_index = 0


func get_display_name() -> String:
	return "Round " + str(int(order_index + 1))
