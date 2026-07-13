extends Node

var route_base = "/score_tables"


func create_score_table(score_table: ScoreTableCreate) -> ScoreTableResponse:
	var route: String = route_base

	await HTTPRequests.POST(route, score_table.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ScoreTableResponse.new(HTTPRequests.get_response_body())


func list_score_tables() -> Array[ScoreTableResponse]:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var score_tables: Array[ScoreTableResponse] = []
	for score_table_json: Dictionary in HTTPRequests.get_response_body():
		score_tables.append(ScoreTableResponse.new(score_table_json))

	return score_tables


func get_score_table(score_table_id: String) -> ScoreTableResponse:
	var route: String = "%s/%s" % [route_base, score_table_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return ScoreTableResponse.new(HTTPRequests.get_response_body())


func update_score_table(score_table_id: String, score_table: ScoreTableUpdate) -> ScoreTableResponse:
	var route: String = "%s/%s" % [route_base, score_table_id]

	await HTTPRequests.PATCH(route, score_table.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ScoreTableResponse.new(HTTPRequests.get_response_body())


func delete_score_table(score_table_id: String) -> void:
	var route: String = "%s/%s" % [route_base, score_table_id]

	await HTTPRequests.DELETE(route)


func list_score_columns_for_score_table(score_table_id: String) -> Array[ScoreColumnResponse]:
	var route: String = "%s/%s/score_columns" % [route_base, score_table_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var score_columns: Array[ScoreColumnResponse] = []
	for score_column_json: Dictionary in HTTPRequests.get_response_body():
		score_columns.append(ScoreColumnResponse.new(score_column_json))

	return score_columns


func update_score_column_order_in_score_table(score_table_id: String, new_order: Array[String]) -> Array[ScoreColumnResponse]:
	var route: String = "%s/%s/score_columns/order" % [route_base, score_table_id]

	await HTTPRequests.PUT(route, new_order)
	if HTTPRequests.failed():
		return []

	var score_columns: Array[ScoreColumnResponse] = []
	for score_column_json: Dictionary in HTTPRequests.get_response_body():
		score_columns.append(ScoreColumnResponse.new(score_column_json))

	return score_columns


func bulk_add_players_to_score_table(score_table_id: String, player_ids: Array[String]) -> Array[Player]:
	var route: String = "%s/%s/players/bulk" % [route_base, score_table_id]

	await HTTPRequests.POST(route, player_ids)
	if HTTPRequests.failed():
		return []

	var players: Array[Player] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players.append(Player.new(player_json))

	return players


func list_players_in_score_table(score_table_id: String) -> Array[Player]:
	var route: String = "%s/%s/players" % [route_base, score_table_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var players: Array[Player] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players.append(Player.new(player_json))

	return players


func update_player_order_in_score_table(score_table_id: String, player_ids: Array[String]) -> Array[Player]:
	var route: String = "%s/%s/players/order" % [route_base, score_table_id]

	await HTTPRequests.PUT(route, player_ids)
	if HTTPRequests.failed():
		return []

	var players: Array[Player] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players.append(Player.new(player_json))

	return players


func remove_player_from_score_table(score_table_id: String, player_id: String) -> Array[Player]:
	var route: String = "%s/%s/players/%s" % [route_base, score_table_id, player_id]

	await HTTPRequests.DELETE(route)
	if HTTPRequests.failed():
		return []

	var players: Array[Player] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players.append(Player.new(player_json))

	return players


func get_score_table_results(score_table_id: String) -> Array[PlayerResults]:
	var route: String = "%s/%s/results" % [route_base, score_table_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var results: Array[PlayerResults] = []
	for result_json: Dictionary in HTTPRequests.get_response_body():
		results.append(PlayerResults.new(result_json))

	return results


func list_candidate_players_for_score_table(score_table_id: String) -> Array[Player]:
	var route: String = "%s/%s/candidate-players" % [route_base, score_table_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var players: Array[Player] = []
	for player_json: Dictionary in HTTPRequests.get_response_body():
		players.append(Player.new(player_json))

	return players
