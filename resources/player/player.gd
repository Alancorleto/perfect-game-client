class_name Player
extends Serializable

var id = ""
var user_id = null
var guest_tournament_id = null

var nickname = ""
var country_code = ""
var name = null
var team_name = null
var birth_date = null
var city = null
var profile_picture_url = null

var profile_picture: ImageTexture


func try_load_profile_picture() -> void:
	if profile_picture_url != null and profile_picture_url != "":
		profile_picture = await HTTPRequests.load_image_from_url(profile_picture_url)
