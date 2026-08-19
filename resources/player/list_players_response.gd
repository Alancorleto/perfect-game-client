class_name ListPlayersResponse
extends Serializable

var players: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0


func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	players.clear()
	for player_dict: Dictionary in from_dict["players"]:
		players.append(Player.new(player_dict))
