class_name ListEventsResponse
extends Serializable

var events: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)
	
	for i in events.size():
		var event_dict: Dictionary = events[i]
		events[i] = Event.new(event_dict)
