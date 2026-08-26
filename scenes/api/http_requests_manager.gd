class_name HTTPRequestsManager
extends HTTPRequest

@export var base_url: String = "http://localhost:8080"

var response_result: int
var response_code: int
var response_headers: PackedStringArray
var response_body: Variant
var access_token: String = ""

var JSON_HEADER: String = "Content-Type: application/json"
var FORM_HEADER: String = "Content-Type: application/x-www-form-urlencoded"


func _ready() -> void:
	request_completed.connect(_on_request_completed)


func make_request(
	method : HTTPClient.Method,
	route: String,
	body: Variant = null,
	is_form: bool = false
) -> void:
	var url = base_url
	url += route
	
	if body == null:
		body = {}
	
	var headers: PackedStringArray = []
	
	var body_string: String = ""
	if not is_form:
		headers.append(JSON_HEADER)
		body_string = JSON.stringify(body, "\t")
	else:
		headers.append(FORM_HEADER)
		var http_client := HTTPClient.new()
		body_string = http_client.query_string_from_dict(body)
	
	if access_token != "":
		headers.append("Authorization: Bearer " + access_token)

	print("--- NEW REQUEST ---")
	print("URL: " + url)
	print("Method: " + _find_native_enum_label("HTTPClient", "Method", method))
	print("Headers: " + str(headers))
	print("Body: " + body_string.substr(0, 1000))
	print("")

	request(url, headers, method, body_string)
	await request_completed


func make_login_request(route: String, username: String, password: String) -> void:
	var url = base_url
	url += route
	var http_client := HTTPClient.new()
	var body := http_client.query_string_from_dict({
		"username": username,
		"password": password
	})
	var headers := PackedStringArray(["Content-Type: application/x-www-form-urlencoded"])

	print("--- NEW REQUEST ---")
	print("URL: " + url)
	print("Method: " + _find_native_enum_label("HTTPClient", "Method", HTTPClient.METHOD_POST))
	print("Headers: " + str(headers))
	print("Body: " + body)
	print("")

	request(url, headers, HTTPClient.METHOD_POST, body)
	await request_completed


func make_request_with_body(method : HTTPClient.Method, route: String, body: Variant) -> void:
	make_request(method, route, body)


func upload_image(route: String, file_path: String, content_type: String, field_name: String) -> void:
	var url = base_url
	url += route
	
	# 1. Generate a unique boundary
	var crypto := Crypto.new()
	var random_bytes := crypto.generate_random_bytes(16)
	var boundary := "--GodotBoundary" + random_bytes.hex_encode()
	
	# 2. Prepare headers
	var headers := [
		"Content-Type: multipart/form-data; boundary=" + boundary
	]
	
	if access_token != "":
		headers.append("Authorization: Bearer " + access_token)
	
	# 3. Construct the body
	var body := PackedByteArray()
	
	# Add the file part
	body.append_array(("\r\n--" + boundary + "\r\n").to_utf8_buffer())
	body.append_array(("Content-Disposition: form-data; name=\"" + field_name + "\"; filename=\"" + file_path.get_file() + "\"\r\n").to_utf8_buffer())
	body.append_array(("Content-Type: " + content_type + "\r\n\r\n").to_utf8_buffer())
	
	# Load file content
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file:
		var file_content := file.get_buffer(file.get_length())
		body.append_array(file_content)
		file.close()
	else:
		push_error("Failed to open file: " + file_path)
		return
		
	# End the multipart body
	body.append_array(("\r\n--" + boundary + "--\r\n").to_utf8_buffer())
	
	# 4. Send the raw request
	var error := request_raw(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("Request failed: " + str(error))
		return
	
	print("--- NEW REQUEST ---")
	print("URL: " + url)
	print("Method: " + _find_native_enum_label("HTTPClient", "Method", HTTPClient.METHOD_POST))
	print("Headers: " + str(headers))
	print("Body: [File]")
	print("")
	
	await request_completed


func GET(route: String, body: Variant = null, is_form: bool = false) -> void:
	await make_request(HTTPClient.METHOD_GET, route, body, is_form)


func POST(route: String, body: Variant = null, is_form: bool = false) -> void:
	await make_request(HTTPClient.METHOD_POST, route, body, is_form)


func PATCH(route: String, body: Variant = null, is_form: bool = false) -> void:
	await make_request(HTTPClient.METHOD_PATCH, route, body, is_form)


func PUT(route: String, body: Variant = null, is_form: bool = false) -> void:
	await make_request(HTTPClient.METHOD_PUT, route, body, is_form)


func DELETE(route: String, body: Variant = null, is_form: bool = false) -> void:
	await make_request(HTTPClient.METHOD_DELETE, route, body, is_form)


func success() -> bool:
	return (
		response_result == HTTPRequest.RESULT_SUCCESS
		and response_code >= 200 and response_code < 300
	)


func failed() -> bool:
	return not success()


func get_response_code() -> int:
	return response_code


func get_response_body() -> Variant:
	return response_body


func load_image_from_url(image_url: String) -> ImageTexture:
	if image_url == "":
		return null

	var scene_tree: SceneTree = get_tree()
	if scene_tree == null:
		return null

	var error := request(image_url)
	if error != OK:
		return null

	var result: Array = await request_completed

	if result.size() < 4:
		return null

	var request_result: int = result[0]
	var image_response_code: int = result[1]
	var body: PackedByteArray = result[3]

	if request_result != HTTPRequest.RESULT_SUCCESS or image_response_code < 200 or image_response_code >= 300:
		return null

	var image := Image.new()
	var extension: String = image_url.get_extension().to_lower()
	var load_error := OK

	if extension in ["jpg", "jpeg"]:
		load_error = image.load_jpg_from_buffer(body)
	elif extension == "webp":
		load_error = image.load_webp_from_buffer(body)
	else:
		load_error = image.load_png_from_buffer(body)
		if load_error != OK:
			load_error = image.load_jpg_from_buffer(body)
			if load_error != OK:
				load_error = image.load_webp_from_buffer(body)

	if load_error != OK:
		return null

	return ImageTexture.create_from_image(image)


func set_access_token(token: String) -> void:
	access_token = token


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

	response_result = result
	print("Request result: " + _find_native_enum_label("HTTPRequest", "Result", result))

	response_code = code
	print("Response code: " + _find_native_enum_label("HTTPClient", "ResponseCode", code) + " (" + str(code) + ")")

	response_headers = headers
	print("Response headers: " + str(headers))

	if JSON_HEADER.to_lower() in headers:
		var body_string: String = body.get_string_from_utf8()
		if body_string != "":
			print("Body: " + JSON.stringify(JSON.parse_string(body_string), "\t"))
		print("")
		if response_code >= 200 and response_code < 300 and response_code != 204:
			response_body = JSON.parse_string(body_string)
		else:
			response_body = null
