class_name ListUsersResponse
extends Serializable

var users: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	users.clear()
	for u_dict: Dictionary in from_dict["users"]:
		users.append(UserResponse.new(u_dict))
