extends Node

var route_base = "/score_columns"


func list_score_columns() -> Array[ScoreColumnResponse]:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var score_columns: Array[ScoreColumnResponse] = []
	for score_column_json: Dictionary in HTTPRequests.get_response_body():
		score_columns.append(ScoreColumnResponse.new(score_column_json))

	return score_columns


func create_score_column(score_column: ScoreColumnCreate) -> ScoreColumnResponse:
	var route: String = route_base

	await HTTPRequests.POST(route, score_column.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ScoreColumnResponse.new(HTTPRequests.get_response_body())


func get_score_column(score_column_id: String) -> ScoreColumnResponse:
	var route: String = "%s/%s" % [route_base, score_column_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return ScoreColumnResponse.new(HTTPRequests.get_response_body())


func update_score_column(score_column_id: String, score_column_update: ScoreColumnUpdate) -> ScoreColumnResponse:
	var route: String = "%s/%s" % [route_base, score_column_id]

	await HTTPRequests.PATCH(route, score_column_update.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ScoreColumnResponse.new(HTTPRequests.get_response_body())


func delete_score_column(score_column_id: String) -> void:
	var route: String = "%s/%s" % [route_base, score_column_id]

	await HTTPRequests.DELETE(route)
