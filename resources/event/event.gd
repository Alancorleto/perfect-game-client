class_name Event
extends Serializable

var id = ""

var name = ""
var country_code = ""
var description = null
var location = null
var start_date = null
var start_time = null
var logo_url = null

var logo: ImageTexture


func try_load_logo() -> void:
	if logo_url != null and logo_url != "":
		logo = await HTTPRequests.load_image_from_url(logo_url)
