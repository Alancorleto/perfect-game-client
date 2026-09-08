class_name TournamentJoinRequest
extends Serializable

var status = TournamentRequestStatus.PENDING
var issued_at = null

var player_id: String
var player: Player = null
var tournament: Tournament = null


func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)
	player = Player.new(from_dict["player"])
	tournament = Tournament.new(from_dict["tournament"])
