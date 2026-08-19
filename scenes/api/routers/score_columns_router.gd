extends Node

var route_base = "/score-columns"


func list_score_columns() -> ListScoreColumnsResponse:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	var response := ListScoreColumnsResponse.new(HTTPRequests.get_response_body())

	return response


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
