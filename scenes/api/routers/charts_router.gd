extends Node

var route_base = "/charts"


func list_charts() -> Array[ChartResponse]:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var charts: Array[ChartResponse] = []
	for chart_json: Dictionary in HTTPRequests.get_response_body():
		charts.append(ChartResponse.new(chart_json))

	return charts


func fuzzy_search_titles(search: String) -> Array[String]:
	var route: String = "%s/titles?search=%s" % [route_base, search]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	return HTTPRequests.get_response_body()


func get_chart(chart_id: String) -> ChartResponse:
	var route: String = "%s/%s" % [route_base, chart_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return ChartResponse.new(HTTPRequests.get_response_body())


func create_chart_for_score_column(chart: ChartCreate, score_column_id: String) -> ChartResponse:
	var route: String = "%s?score_column_id=%s" % [route_base, score_column_id]

	await HTTPRequests.POST(route, chart.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ChartResponse.new(HTTPRequests.get_response_body())


func create_chart_for_chart_column(chart: ChartCreate, chart_column_id: String, chart_column_player_id: String) -> ChartResponse:
	var route: String = "%s?chart_column_id=%s&chart_column_player_id=%s" % [route_base, chart_column_id, chart_column_player_id]

	await HTTPRequests.POST(route, chart.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ChartResponse.new(HTTPRequests.get_response_body())


func update_chart(chart_id: String, chart: ChartUpdate) -> ChartResponse:
	var route: String = "%s/%s" % [route_base, chart_id]

	await HTTPRequests.PATCH(route, chart.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ChartResponse.new(HTTPRequests.get_response_body())


func delete_chart(chart_id: String) -> void:
	var route: String = "%s/%s" % [route_base, chart_id]

	await HTTPRequests.DELETE(route)


func upload_chart_title(chart_id: String, title_file: PackedByteArray) -> ChartResponse:
	var route: String = "%s/%s/title" % [route_base, chart_id]
	var body: Dictionary = {
		"title_file": title_file,
	}

	await HTTPRequests.POST(route, body)
	if HTTPRequests.failed():
		return null

	return ChartResponse.new(HTTPRequests.get_response_body())
