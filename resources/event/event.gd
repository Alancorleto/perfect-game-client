class_name Event
extends Resource

signal logo_loaded()

var id = ""
var name = ""
var country_code = ""
var description = null
var location = null
var start_date = null
var start_time = null
var logo_url = null
var logo: ImageTexture


func _init(from_event: EventResponse) -> void:
	id = from_event.id
	name = from_event.name
	country_code = from_event.country_code
	description = from_event.description
	location = from_event.location
	start_date = from_event.start_date
	start_time = from_event.start_time
	logo_url = from_event.logo_url

	if logo_url != null and logo_url != "":
		logo = await HTTPRequests.load_image_from_url(logo_url)
		logo_loaded.emit()
