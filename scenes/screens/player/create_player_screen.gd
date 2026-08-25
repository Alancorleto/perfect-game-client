extends Control

@onready var nickname_line_edit: LineEdit = %NicknameLineEdit
@onready var name_line_edit: LineEdit = %NameLineEdit
@onready var country_line_edit: LineEdit = %CountryLineEdit
@onready var team_name_line_edit: LineEdit = %TeamNameLineEdit
@onready var birth_date_day_line_edit: LineEdit = %BirthDateDayLineEdit
@onready var birth_date_month_line_edit: LineEdit = %BirthDateMonthLineEdit
@onready var birth_date_year_line_edit: LineEdit = %BirthDateYearLineEdit
@onready var city_line_edit: LineEdit = %CityLineEdit
@onready var profile_picture: TextureRect = %ProfilePicture
@onready var upload_profile_picture_button: Button = %UploadProfilePictureButton

@onready var confirm_button: Button = %ConfirmButton

@onready var file_dialog: FileDialog = $FileDialog

const SELECT_MODE_SCREEN_PATH := "res://scenes/placeholder/screens/select_mode_screen.tscn"

var profile_picture_bytes: PackedByteArray


func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	upload_profile_picture_button.pressed.connect(_on_upload_profile_picture_button_pressed)
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)


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
		if profile_picture_bytes:
			player = await PlayersRouter.upload_profile_picture(player.id, profile_picture_bytes)
			
			if not player:
				return false
		
		Globals.current_player = player
		
		return true
	else:
		return false


func _on_confirm_button_pressed() -> void:
	App.show_loading_sign("Creating player profile...")

	var success: bool = await _create_player()

	App.hide_loading_sign()
	if success:
		await App.show_dialog("Player profile created successfully!")
		App.change_screen(SELECT_MODE_SCREEN_PATH)
	else:
		await App.show_error_dialog("Error while creating player profile.")


func _on_upload_profile_picture_button_pressed() -> void:
	file_dialog.show()


func _on_file_dialog_file_selected(path: String):
	profile_picture_bytes = FileAccess.get_file_as_bytes(path)
	
	if not profile_picture_bytes:
		return
	
	var image := Image.load_from_file(path)
	var texture := ImageTexture.create_from_image(image)
	profile_picture.texture = texture
	profile_picture.show()
