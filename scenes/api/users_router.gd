extends Node

var route_base = "/users"


func list_users() -> Array[UserResponse]:
	var route: String = route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return []

	var users: Array[UserResponse] = []

	for user_json: Dictionary in HTTPRequests.get_response_body():
		var user: UserResponse = UserResponse.new(user_json)
		users.append(user)

	return users


func create_user(user: UserCreate) -> UserResponse:
	var route: String = route_base

	await HTTPRequests.POST(route, user.to_dictionary())
	if HTTPRequests.failed():
		return null

	return UserResponse.new(HTTPRequests.get_response_body())


func get_currently_logged_user() -> UserResponse:
	var route: String = "%s/me" % route_base

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return UserResponse.new(HTTPRequests.get_response_body())


func get_user(user_id: String) -> UserResponse:
	var route: String = "%s/%s" % [route_base, user_id]

	await HTTPRequests.GET(route)
	if HTTPRequests.failed():
		return null

	return UserResponse.new(HTTPRequests.get_response_body())


func update_user(user_id: String, user_update: UserUpdate) -> UserResponse:
	var route: String = "%s/%s" % [route_base, user_id]

	await HTTPRequests.PATCH(route, user_update.to_dictionary())
	if HTTPRequests.failed():
		return null

	return UserResponse.new(HTTPRequests.get_response_body())


func delete_user(user_id: String) -> void:
	var route: String = "%s/%s" % [route_base, user_id]

	await HTTPRequests.DELETE(route)


func login(username: String, password: String) -> Token:
	var route: String = "/token"
	var body: Dictionary = {
		"username": username,
		"password": password,
	}

	await HTTPRequests.POST(route, body)
	if HTTPRequests.failed():
		return null

	var token := Token.new(HTTPRequests.get_response_body())

	HTTPRequests.set_access_token(token.access_token)

	return token


func refresh_access_token(refresh_token: String) -> Token:
	var route: String = "/token/refresh"
	var body: Dictionary = {
		"refresh_token": refresh_token,
	}

	await HTTPRequests.POST(route, body)
	if HTTPRequests.failed():
		return null

	var token := Token.new(HTTPRequests.get_response_body())
	HTTPRequests.set_access_token(token.access_token)

	return token

func revoke_refresh_token(refresh_token: String) -> void:
	var route: String = "/token/revoke"
	var body: Dictionary = {
		"refresh_token": refresh_token,
	}

	await HTTPRequests.POST(route, body)


func request_password_reset(body: PasswordResetRequest) -> Dictionary:
	var route: String = "/password-reset/request"

	await HTTPRequests.POST(route, body.to_dictionary())
	if HTTPRequests.failed():
		return {}

	return HTTPRequests.get_response_body()


func verify_password_reset_code(body: PasswordResetVerify) -> Dictionary:
	var route: String = "/password-reset/verify"

	await HTTPRequests.POST(route, body.to_dictionary())
	if HTTPRequests.failed():
		return {}

	return HTTPRequests.get_response_body()


func confirm_password_reset(body: PasswordResetConfirm) -> Dictionary:
	var route: String = "/password-reset/confirm"

	await HTTPRequests.POST(route, body.to_dictionary())
	if HTTPRequests.failed():
		return {}

	return HTTPRequests.get_response_body()
