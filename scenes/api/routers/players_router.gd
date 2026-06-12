extends Node

var route_base = "/players"


func list_players(country_code: String = "") -> Array[PlayerResponse]:
	var route: String = route_base
	if country_code != "":
		route += "?country_code=%s" % country_code

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var players: Array[PlayerResponse] = []

	for player_json: Dictionary in HTTPRequests.get_response_body():
		var player: PlayerResponse = PlayerResponse.new(player_json)
		players.append(player)

	return players


func get_player(player_id: String) -> PlayerResponse:
	var route: String = "%s/%s" % [route_base, player_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return PlayerResponse.new(HTTPRequests.get_response_body())


func create_player(player: PlayerCreate) -> PlayerResponse:
	var route: String = route_base

	await HTTPRequests.POST(route, player.to_dictionary())
	if HTTPRequests.failed():
		return null

	return PlayerResponse.new(HTTPRequests.get_response_body())


func create_guest_player(event_id: String, player: PlayerCreate) -> PlayerResponse:
	var route: String = "%s/guest/%s" % [route_base, event_id]

	await HTTPRequests.POST(route, player.to_dictionary())
	if HTTPRequests.failed():
		return null

	return PlayerResponse.new(HTTPRequests.get_response_body())


func update_player(player_id: String, player: PlayerUpdate) -> PlayerResponse:
	var route: String = "%s/%s" % [route_base, player_id]

	await HTTPRequests.PATCH(route, player.to_dictionary())
	if HTTPRequests.failed():
		return null

	return PlayerResponse.new(HTTPRequests.get_response_body())


func delete_player(player_id: String) -> void:
	var route: String = "%s/%s" % [route_base, player_id]

	await HTTPRequests.DELETE(route)


func upload_profile_picture(player_id: String, profile_picture: PackedByteArray) -> PlayerResponse:
	var route: String = "%s/%s/profile_picture" % [route_base, player_id]
	var body: Dictionary = {
		"profile_picture": profile_picture,
	}

	await HTTPRequests.POST(route, body)
	if HTTPRequests.failed():
		return null

	return PlayerResponse.new(HTTPRequests.get_response_body())
