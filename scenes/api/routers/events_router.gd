extends Node

var route_base = "/events"


func list_events(country_code: String = "") -> Array[EventResponse]:
	var route: String = route_base
	if country_code != "":
		route += "?country_code=%s" % country_code

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var events: Array[EventResponse] = []

	for event_json: Dictionary in HTTPRequests.get_response_body():
		var event: EventResponse = EventResponse.new(event_json)
		events.append(event)

	return events


func get_event(event_id: String) -> EventResponse:
	var route: String = "%s/%s" % [route_base, event_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return EventResponse.new(HTTPRequests.get_response_body())


func create_event(event: EventCreate) -> EventResponse:
	var route: String = route_base

	await HTTPRequests.POST(route, event.to_dictionary())
	if HTTPRequests.failed():
		return null

	return EventResponse.new(HTTPRequests.get_response_body())


func update_event(event_id: String, event: EventUpdate) -> EventResponse:
	var route: String = "%s/%s" % [route_base, event_id]

	await HTTPRequests.PATCH(route, event.to_dictionary())
	if HTTPRequests.failed():
		return null

	return EventResponse.new(HTTPRequests.get_response_body())


func delete_event(event_id: String) -> void:
	var route: String = "%s/%s" % [route_base, event_id]

	await HTTPRequests.DELETE(route)


func list_event_tournaments(event_id: String) -> Array[TournamentResponse]:
	var route: String = "%s/%s/tournaments" % [route_base, event_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var tournaments: Array[TournamentResponse] = []

	for tournament_json: Dictionary in HTTPRequests.get_response_body():
		var tournament: TournamentResponse = TournamentResponse.new(tournament_json)
		tournaments.append(tournament)

	return tournaments


func list_event_organizers(event_id: String) -> Array[PlayerResponse]:
	var route: String = "%s/%s/organizers" % [route_base, event_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var organizers: Array[PlayerResponse] = []

	for player_json: Dictionary in HTTPRequests.get_response_body():
		var player: PlayerResponse = PlayerResponse.new(player_json)
		organizers.append(player)

	return organizers


func add_organizer_to_event(event_id: String, player_id: String) -> Array[PlayerResponse]:
	var route: String = "%s/%s/organizers/%s" % [route_base, event_id, player_id]

	await HTTPRequests.POST(route)
	if HTTPRequests.failed():
		return []

	var organizers: Array[PlayerResponse] = []

	for player_json: Dictionary in HTTPRequests.get_response_body():
		var player: PlayerResponse = PlayerResponse.new(player_json)
		organizers.append(player)

	return organizers


func remove_organizer_from_event(event_id: String, player_id: String) -> Array[PlayerResponse]:
	var route: String = "%s/%s/organizers/%s" % [route_base, event_id, player_id]

	await HTTPRequests.DELETE(route)
	if HTTPRequests.failed():
		return []

	var organizers: Array[PlayerResponse] = []

	for player_json: Dictionary in HTTPRequests.get_response_body():
		var player: PlayerResponse = PlayerResponse.new(player_json)
		organizers.append(player)

	return organizers


func upload_event_logo(event_id: String, logo: PackedByteArray) -> EventResponse:
	var route: String = "%s/%s/logo" % [route_base, event_id]
	var body: Dictionary = {
		"logo": logo,
	}

	await HTTPRequests.POST(route, body)
	if HTTPRequests.failed():
		return null

	return EventResponse.new(HTTPRequests.get_response_body())
