class_name PlayerInTournament
extends Serializable

var player: Player
var has_paid_entry: bool = false


func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)
	player = Player.new(from_dict["player"])
