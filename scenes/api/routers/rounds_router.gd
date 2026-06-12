extends Node

var route_base = "/rounds"


func list_rounds() -> Array[RoundResponse]:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var rounds: Array[RoundResponse] = []
	for round_json: Dictionary in HTTPRequests.get_response_body():
		rounds.append(RoundResponse.new(round_json))

	return rounds


func get_round(round_id: String) -> RoundResponse:
	var route: String = "%s/%s" % [route_base, round_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func create_round(round: RoundCreate) -> RoundResponse:
	var route: String = route_base

	await HTTPRequests.POST(route, round.to_dictionary())
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func update_round(round_id: String, round: RoundUpdate) -> RoundResponse:
	var route: String = "%s/%s" % [route_base, round_id]

	await HTTPRequests.PATCH(route, round.to_dictionary())
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func delete_round(round_id: String) -> void:
	var route: String = "%s/%s" % [route_base, round_id]

	await HTTPRequests.DELETE(route)


func list_score_tables_in_round(round_id: String) -> Array[ScoreTableResponse]:
	var route: String = "%s/%s/score_tables" % [route_base, round_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var score_tables: Array[ScoreTableResponse] = []
	for score_table_json: Dictionary in HTTPRequests.get_response_body():
		score_tables.append(ScoreTableResponse.new(score_table_json))

	return score_tables


func change_score_table_order_in_round(round_id: String, new_score_table_order: Array[String]) -> Array[ScoreTableResponse]:
	var route: String = "%s/%s/score_tables/order" % [route_base, round_id]

	await HTTPRequests.PUT(route, new_score_table_order)
	if HTTPRequests.failed():
		return []

	var score_tables: Array[ScoreTableResponse] = []
	for score_table_json: Dictionary in HTTPRequests.get_response_body():
		score_tables.append(ScoreTableResponse.new(score_table_json))

	return score_tables


func delete_all_scores_in_round(round_id: String) -> void:
	var route: String = "%s/%s/scores" % [route_base, round_id]

	await HTTPRequests.DELETE(route)


func start_round(round_id: String) -> RoundResponse:
	var route: String = "%s/%s/start" % [route_base, round_id]

	await HTTPRequests.POST(route)
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func cancel_round_start(round_id: String) -> RoundResponse:
	var route: String = "%s/%s/cancel-start" % [route_base, round_id]

	await HTTPRequests.POST(route)
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func pause_round(round_id: String) -> RoundResponse:
	var route: String = "%s/%s/pause" % [route_base, round_id]

	await HTTPRequests.POST(route)
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func unpause_round(round_id: String) -> RoundResponse:
	var route: String = "%s/%s/unpause" % [route_base, round_id]

	await HTTPRequests.POST(route)
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func finish_round(round_id: String) -> RoundResponse:
	var route: String = "%s/%s/finish" % [route_base, round_id]

	await HTTPRequests.POST(route)
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func cancel_round_finish(round_id: String) -> RoundResponse:
	var route: String = "%s/%s/cancel-finish" % [route_base, round_id]

	await HTTPRequests.POST(route)
	if HTTPRequests.failed():
		return null

	return RoundResponse.new(HTTPRequests.get_response_body())


func get_qualifying_players_in_round(round_id: String) -> Array[PlayerResponse]:
	var route: String = "%s/%s/qualifying-players" % [route_base, round_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var players: Array[PlayerResponse] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players.append(PlayerResponse.new(player_json))

	return players
