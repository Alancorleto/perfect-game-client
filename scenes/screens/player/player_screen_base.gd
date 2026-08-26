class_name PlayerScreenBase
extends Control

@export_multiline var success_message: String
@export_multiline var failure_message: String

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
var profile_picture_path: String = ""


func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	upload_profile_picture_button.pressed.connect(_on_upload_profile_picture_button_pressed)
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	
	_populate()


func _submit_form() -> bool:
	await get_tree().process_frame
	return true


func _populate() -> void:
	pass


func _on_confirm_button_pressed() -> void:
	App.show_loading_sign("Creating player profile...")

	var success: bool = await _submit_form()

	App.hide_loading_sign()
	if success:
		await App.show_dialog(success_message)
		App.change_screen(SELECT_MODE_SCREEN_PATH)
	else:
		await App.show_error_dialog(failure_message)


func _on_upload_profile_picture_button_pressed() -> void:
	file_dialog.show()


func _on_file_dialog_file_selected(path: String):
	profile_picture_bytes = FileAccess.get_file_as_bytes(path)
	
	if not profile_picture_bytes:
		return
	
	profile_picture_path = path
	
	var image := Image.load_from_file(path)
	var texture := ImageTexture.create_from_image(image)
	profile_picture.texture = texture
	profile_picture.show()
