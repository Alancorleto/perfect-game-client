class_name HTTPRequestsManager
extends HTTPRequest

@export var base_url: String = "http://localhost:8080"

var response_result: int
var response_code: int
var response_headers: PackedStringArray
var response_body: Variant


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request(method : HTTPClient.Method, route: String, body: Variant = null, headers: PackedStringArray = []) -> void:
	var url = base_url
	url += route
	if body == null:
		body = ""
	var body_string: String = JSON.stringify(body, "\t")
	#var body_string: String = JSON.stringify(body)
	headers.append("Content-Type: application/json")

	print("--- NEW REQUEST ---")
	print("URL: " + url)
	print("Method: " + _find_native_enum_label("HTTPClient", "Method", method))
	print("Headers: " + str(headers))
	print("Body: " + body_string)
	print("")

	request(url, headers, method, body_string)
	await request_completed


func make_request_with_body(method : HTTPClient.Method, route: String, body: Variant) -> void:
	make_request(method, route, body)


func GET(route: String, body: Variant = null) -> void:
	await make_request(HTTPClient.METHOD_GET, route, body)


func POST(route: String, body: Variant = null) -> void:
	await make_request(HTTPClient.METHOD_POST, route, body)


func PATCH(route: String, body: Variant = null) -> void:
	await make_request(HTTPClient.METHOD_PATCH, route, body)


func PUT(route: String, body: Variant = null) -> void:
	await make_request(HTTPClient.METHOD_PUT, route, body)


func DELETE(route: String, body: Variant = null) -> void:
	await make_request(HTTPClient.METHOD_DELETE, route, body)


func success() -> bool:
	return (
		response_result == HTTPRequest.RESULT_SUCCESS
		and response_code >= 200 and response_code < 300
	)


func failed() -> bool:
	return not success()


func get_response_code() -> int:
	return response_code


func _find_native_enum_label(type_name: StringName, enum_name: StringName, enum_value: int) -> String:
	for value_label in ClassDB.class_get_enum_constants(type_name, enum_name):
		var v = ClassDB.class_get_integer_constant(type_name, value_label)
		if v == enum_value:
			return value_label
	return "unknown"


func _on_request_completed(
	result: int,
	code: int,
	headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	print("--- NEW RESPONSE ---")
	print("Request result: " + _find_native_enum_label("HTTPRequest", "Result", result))
	print("Response code: " + _find_native_enum_label("HTTPClient", "ResponseCode", code) + " (" + str(code) + ")")
	print("Response headers: " + str(headers))
	var body_string: String = body.get_string_from_utf8()
	if body_string != "":
		print("Body: " + JSON.stringify(JSON.parse_string(body_string), "\t"))
	print("")

	response_result = result
	response_code = code
	response_headers = headers
	if response_code >= 200 and response_code < 300 and response_code != 204:
		response_body = JSON.parse_string(body_string)
	else:
		response_body = null
