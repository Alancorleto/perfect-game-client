extends Control

@onready var nickname_line_edit: LineEdit = %NicknameLineEdit
@onready var country_line_edit: LineEdit = %CountryLineEdit
@onready var seach_button: Button = %SeachButton
@onready var players_container: VBoxContainer = %PlayersContainer

const PlayerPanelScene := preload("res://scenes/ui_elements/player_panel.tscn")

const EVENT_SCREEN_PATH := "res://scenes/screens/event/event_screen.tscn"


func _ready() -> void:
	_search_players()
	seach_button.pressed.connect(_search_players)


func _search_players() -> void:
	_clear_players()
	
	App.show_loading_sign("Searching players...")
	
	var nickname: String = nickname_line_edit.text
	var country_code: String = country_line_edit.text
	var response: ListPlayersResponse = await PlayersRouter.list_players(nickname, country_code)
	
	if not response:
		App.hide_loading_sign()
		await App.show_error_dialog("Error listing players.")
		return
	
	for player: Player in response.players:
		var player_panel: PlayerPanel = PlayerPanelScene.instantiate()
		players_container.add_child(player_panel)
		player_panel.populate(player)
		player_panel.pressed.connect(_add_organizer.bind(player))
	
	App.hide_loading_sign()


func _add_organizer(player: Player) -> void:
	App.show_loading_sign("Adding organizer...")
	
	await EventsRouter.add_organizer_to_event(Globals.current_event.id, player.id)
	
	App.hide_loading_sign()
	
	if HTTPRequests.failed():
		App.show_error_dialog("Error adding organizer.")
		return
	
	App.show_dialog("Organizer added successfully!")
	
	App.change_screen(EVENT_SCREEN_PATH)


func _clear_players() -> void:
	for player_panel: PlayerPanel in players_container.get_children():
		player_panel.queue_free()
