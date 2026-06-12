extends Node

var route_base = "/chart_columns"


func list_chart_columns() -> Array[ChartColumnResponse]:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var chart_columns: Array[ChartColumnResponse] = []
	for chart_column_json: Dictionary in HTTPRequests.get_response_body():
		chart_columns.append(ChartColumnResponse.new(chart_column_json))

	return chart_columns


func create_chart_column(chart_column: ChartColumnCreate) -> ChartColumnResponse:
	var route: String = route_base

	await HTTPRequests.POST(route, chart_column.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ChartColumnResponse.new(HTTPRequests.get_response_body())


func get_chart_column(chart_column_id: String) -> ChartColumnResponse:
	var route: String = "%s/%s" % [route_base, chart_column_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return ChartColumnResponse.new(HTTPRequests.get_response_body())


func update_chart_column(chart_column_id: String, chart_column_update: ChartColumnUpdate) -> ChartColumnResponse:
	var route: String = "%s/%s" % [route_base, chart_column_id]

	await HTTPRequests.PATCH(route, chart_column_update.to_dictionary())
	if HTTPRequests.failed():
		return null

	return ChartColumnResponse.new(HTTPRequests.get_response_body())


func delete_chart_column(chart_column_id: String) -> void:
	var route: String = "%s/%s" % [route_base, chart_column_id]

	await HTTPRequests.DELETE(route)
