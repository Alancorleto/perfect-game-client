extends Control

@onready var nickname_line_edit: LineEdit = %NicknameLineEdit
@onready var name_line_edit: LineEdit = %NameLineEdit
@onready var country_line_edit: LineEdit = %CountryLineEdit
@onready var team_name_line_edit: LineEdit = %TeamNameLineEdit
@onready var birth_date_day_line_edit: LineEdit = %BirthDateDayLineEdit
@onready var birth_date_month_line_edit: LineEdit = %BirthDateMonthLineEdit
@onready var birth_date_year_line_edit: LineEdit = %BirthDateYearLineEdit
@onready var city_line_edit: LineEdit = %CityLineEdit

@onready var confirm_button: Button = %ConfirmButton

const SELECT_MODE_SCREEN_PATH := "res://scenes/placeholder/screens/select_mode_screen.tscn"


func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_button_pressed)


func _create_player() -> bool:
	var player_create := PlayerCreate.new()

	player_create.nickname = nickname_line_edit.text
	player_create.name = name_line_edit.text
	player_create.country_code = country_line_edit.text
	player_create.team_name = team_name_line_edit.text
	player_create.birth_date = "%s-%s-%s" % [birth_date_year_line_edit.text, birth_date_month_line_edit.text, birth_date_day_line_edit.text]
	player_create.city = city_line_edit.text
	player_create.user_id = Globals.current_user.id
	
	var player: Player = await PlayersRouter.create_player(player_create)
	
	if player:
		Globals.current_player = player
		return true
	else:
		return false


func _on_confirm_button_pressed() -> void:
	App.show_loading_sign("Creating player profile...")
	
	var success: bool = await _create_player()
	
	if success:
		App.hide_loading_sign()
		await App.show_dialog("Player profile created successfully!")
		App.change_screen(SELECT_MODE_SCREEN_PATH)
	else:
		await App.show_error_dialog("Error while creating player profile.")
