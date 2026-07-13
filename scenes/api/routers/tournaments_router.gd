extends Node

var route_base = "/tournaments"


func list_tournaments() -> Array[Tournament]:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var tournaments: Array[Tournament] = []

	for tournament_json: Dictionary in HTTPRequests.get_response_body():
		var tournament: Tournament = Tournament.new(tournament_json)
		tournaments.append(tournament)

	return tournaments


func get_tournament(tournament_id: String) -> Tournament:
	var route: String = "%s/%s" % [route_base, tournament_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return Tournament.new(HTTPRequests.get_response_body())


func create_tournament(tournament: TournamentCreate) -> Tournament:
	var route: String = route_base

	await HTTPRequests.POST(route, tournament.to_dictionary())
	if HTTPRequests.failed():
		return null

	return Tournament.new(HTTPRequests.get_response_body())


func update_tournament(tournament_id: String, tournament: TournamentUpdate) -> Tournament:
	var route: String = "%s/%s" % [route_base, tournament_id]

	await HTTPRequests.PATCH(route, tournament.to_dictionary())
	if HTTPRequests.failed():
		return null

	return Tournament.new(HTTPRequests.get_response_body())


func delete_tournament(tournament_id: String) -> void:
	var route: String = "%s/%s" % [route_base, tournament_id]

	await HTTPRequests.DELETE(route)


func add_guest_player_to_tournament(tournament_id: String, player_id: String) -> Array[Player]:
	var route: String = "%s/%s/players/%s" % [route_base, tournament_id, player_id]

	await HTTPRequests.POST(route)
	if HTTPRequests.failed():
		return []

	var players: Array[Player] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players.append(Player.new(player_json))
	return players


func bulk_add_guest_players_to_tournament(tournament_id: String, player_ids: Array[String]) -> Array[Player]:
	var route: String = "%s/%s/players/bulk" % [route_base, tournament_id]
	var body: Array = player_ids

	await HTTPRequests.POST(route, body)
	if HTTPRequests.failed():
		return []

	var players: Array[Player] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players.append(Player.new(player_json))
	return players


func list_tournament_invitations(tournament_id: String) -> Array[TournamentInvitationResponse]:
	var route: String = "%s/%s/invitations" % [route_base, tournament_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var invitations: Array[TournamentInvitationResponse] = []
	for invitation_json: Dictionary in HTTPRequests.get_response_body():
		invitations.append(TournamentInvitationResponse.new(invitation_json))

	return invitations


func invite_player_to_tournament(tournament_id: String, player_id: String) -> void:
	var route: String = "%s/%s/invitations/%s/" % [route_base, tournament_id, player_id]

	await HTTPRequests.POST(route)


func accept_tournament_invitation(tournament_id: String) -> void:
	var route: String = "%s/%s/invitations/accept" % [route_base, tournament_id]

	await HTTPRequests.POST(route)


func decline_tournament_invitation(tournament_id: String) -> void:
	var route: String = "%s/%s/invitations/decline" % [route_base, tournament_id]

	await HTTPRequests.POST(route)


func list_tournament_join_requests(tournament_id: String) -> Array[TournamentJoinRequestResponse]:
	var route: String = "%s/%s/join_requests" % [route_base, tournament_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var join_requests: Array[TournamentJoinRequestResponse] = []
	for join_request_json: Dictionary in HTTPRequests.get_response_body():
		join_requests.append(TournamentJoinRequestResponse.new(join_request_json))

	return join_requests


func request_join_tournament(tournament_id: String) -> void:
	var route: String = "%s/%s/join_requests" % [route_base, tournament_id]

	await HTTPRequests.POST(route)


func accept_tournament_join_request(tournament_id: String, player_id: String) -> void:
	var route: String = "%s/%s/join_requests/%s/accept" % [route_base, tournament_id, player_id]

	await HTTPRequests.POST(route)


func decline_tournament_join_request(tournament_id: String, player_id: String) -> void:
	var route: String = "%s/%s/join_requests/%s/decline" % [route_base, tournament_id, player_id]

	await HTTPRequests.POST(route)


func list_players_in_tournament(tournament_id: String) -> Array[PlayerInTournament]:
	var route: String = "%s/%s/players" % [route_base, tournament_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var players_in_tournament: Array[PlayerInTournament] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players_in_tournament.append(PlayerInTournament.new(player_json))

	return players_in_tournament


func update_player_in_tournament(tournament_id: String, player_id: String, player_in_tournament: PlayerInTournamentUpdate) -> PlayerInTournament:
	var route: String = "%s/%s/players/%s" % [route_base, tournament_id, player_id]

	await HTTPRequests.PATCH(route, player_in_tournament.to_dictionary())
	if HTTPRequests.failed():
		return null

	return PlayerInTournament.new(HTTPRequests.get_response_body())


func remove_player_from_tournament(tournament_id: String, player_id: String) -> Array[PlayerInTournament]:
	var route: String = "%s/%s/players/%s" % [route_base, tournament_id, player_id]

	await HTTPRequests.DELETE(route)
	if HTTPRequests.failed():
		return []

	return HTTPRequests.get_response_body()


func list_rounds_in_tournament(tournament_id: String) -> Array[RoundResponse]:
	var route: String = "%s/%s/rounds" % [route_base, tournament_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var rounds: Array[RoundResponse] = []
	for round_json: Dictionary in HTTPRequests.get_response_body():
		rounds.append(RoundResponse.new(round_json))
	return rounds


func change_round_order_in_tournament(tournament_id: String, new_round_order: Array[String]) -> Array[RoundResponse]:
	var route: String = "%s/%s/rounds/order" % [route_base, tournament_id]

	await HTTPRequests.PUT(route, new_round_order)
	if HTTPRequests.failed():
		return []

	var rounds: Array[RoundResponse] = []
	for round_json: Dictionary in HTTPRequests.get_response_body():
		rounds.append(RoundResponse.new(round_json))
	return rounds
