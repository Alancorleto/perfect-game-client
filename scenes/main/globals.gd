extends Node

var recovery_email: String = ""
var recovery_code: String = ""

var current_event: Event
var current_tournament: Tournament
var current_round: Round


func is_logged_in() -> bool:
	return HTTPRequests.access_token != ""
