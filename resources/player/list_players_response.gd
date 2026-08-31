class_name ListPlayersResponse
extends Serializable

var players: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0


func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	for i in players.size():
		var player_dict: Dictionary = players[i]
		players[i] = Player.new(player_dict)
