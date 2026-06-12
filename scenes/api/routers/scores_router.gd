extends Node

var route_base = "/scores"


func list_scores() -> Array[ScoreResponse]:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var scores: Array[ScoreResponse] = []
	for score_json: Dictionary in HTTPRequests.get_response_body():
		scores.append(ScoreResponse.new(score_json))

	return scores


func get_score(score_id: String) -> ScoreResponse:
	var route: String = "%s/%s" % [route_base, score_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return ScoreResponse.new(HTTPRequests.get_response_body())


func create_score(score: ScoreCreate) -> ScoreResponse:
	var route: String = route_base

	await HTTPRequests.POST(route, score.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ScoreResponse.new(HTTPRequests.get_response_body())


func update_score(score_id: String, score: ScoreUpdate) -> ScoreResponse:
	var route: String = "%s/%s" % [route_base, score_id]

	await HTTPRequests.PATCH(route, score.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ScoreResponse.new(HTTPRequests.get_response_body())


func delete_score(score_id: String) -> void:
	var route: String = "%s/%s" % [route_base, score_id]

	await HTTPRequests.DELETE(route)
