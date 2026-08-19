class_name ListEventsResponse
extends Serializable

var events: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	events.clear()
	for ev_dict: Dictionary in from_dict["events"]:
		events.append(Event.new(ev_dict))
