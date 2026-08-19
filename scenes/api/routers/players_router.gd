extends Node

var route_base = "/players"


func list_players(country_code: String = "", offset: int = 0, size: int = 20) -> ListPlayersResponse:
	var route: String = route_base

	route += "?offset=%d&size=%d" % [offset, size]

	if country_code != "":
		route += "&country_code=%s" % country_code

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	var response_json = HTTPRequests.get_response_body()

	var response = ListPlayersResponse.new(response_json)

	return response


func get_player(player_id: String) -> Player:
	var route: String = "%s/%s" % [route_base, player_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return Player.new(HTTPRequests.get_response_body())


func create_player(player: PlayerCreate) -> Player:
	var route: String = route_base

	await HTTPRequests.POST(route, player.to_dictionary())
	if HTTPRequests.failed():
		return null

	return Player.new(HTTPRequests.get_response_body())



func update_player(player_id: String, player: PlayerUpdate) -> Player:
	var route: String = "%s/%s" % [route_base, player_id]

	await HTTPRequests.PATCH(route, player.to_dictionary())
	if HTTPRequests.failed():
		return null

	return Player.new(HTTPRequests.get_response_body())


func delete_player(player_id: String) -> void:
	var route: String = "%s/%s" % [route_base, player_id]

	await HTTPRequests.DELETE(route)


func upload_profile_picture(player_id: String, profile_picture: PackedByteArray) -> Player:
	var route: String = "%s/%s/profile-picture" % [route_base, player_id]
	var body: Dictionary = {
		"profile_picture": profile_picture,
	}

	await HTTPRequests.POST(route, body)
	if HTTPRequests.failed():
		return null

	return Player.new(HTTPRequests.get_response_body())
