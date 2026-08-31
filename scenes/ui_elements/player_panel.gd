class_name PlayerPanel
extends PanelContainer

signal pressed()

@onready var button: Button = %Button
@onready var flag_texture_rect: TextureRect = %FlagTextureRect
@onready var nickname_label: Label = %NicknameLabel


func populate(player: Player) -> void:
	nickname_label.text = player.nickname

	button.pressed.connect(_notify_pressed)


func _notify_pressed() -> void:
	pressed.emit()
