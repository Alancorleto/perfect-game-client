class_name EventDataScreenBase
extends Control

@export var in_progress_message: String
@export var success_message: String
@export var failure_message: String

@onready var description_text_edit: TextEdit = %DescriptionTextEdit
@onready var time_hour_line_edit: LineEdit = %TimeHourLineEdit
@onready var time_minute_line_edit: LineEdit = %TimeMinuteLineEdit
@onready var location_line_edit: LineEdit = %LocationLineEdit
@onready var country_line_edit: LineEdit = %CountryLineEdit
@onready var name_line_edit: LineEdit = %NameLineEdit
@onready var date_day_line_edit: LineEdit = %DateDayLineEdit
@onready var date_month_line_edit: LineEdit = %DateMonthLineEdit
@onready var date_year_line_edit: LineEdit = %DateYearLineEdit

@onready var logo: TextureRect = %Logo
@onready var upload_logo_button: Button = %UploadLogoButton
@onready var file_dialog: FileDialog = $FileDialog

@onready var confirm_button: Button = %ConfirmButton

const EVENT_SCREEN_PATH := "res://scenes/screens/event/event_screen.tscn"

var logo_bytes: PackedByteArray
var logo_path: String = ""


func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	upload_logo_button.pressed.connect(_on_upload_logo_button_pressed)
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	
	_populate()


func _submit_form() -> bool:
	await get_tree().process_frame
	return true


func _populate() -> void:
	pass


func _on_confirm_button_pressed() -> void:
	App.show_loading_sign(in_progress_message)

	var success: bool = await _submit_form()

	App.hide_loading_sign()
	if success:
		await App.show_dialog(success_message)
		App.change_screen(EVENT_SCREEN_PATH)
	else:
		await App.show_error_dialog(failure_message)


func _on_upload_logo_button_pressed() -> void:
	file_dialog.show()


func _on_file_dialog_file_selected(path: String):
	logo_bytes = FileAccess.get_file_as_bytes(path)
	
	if not logo_bytes:
		return
	
	logo_path = path
	
	var image := Image.load_from_file(path)
	var texture := ImageTexture.create_from_image(image)
	logo.texture = texture
	logo.show()
