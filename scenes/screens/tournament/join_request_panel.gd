class_name JoinRequestPanel
extends HBoxContainer

signal accepted()
signal declined()

@onready var nickname_label: Label = $NicknameLabel
@onready var accept_button: Button = $AcceptButton
@onready var decline_button: Button = $DeclineButton


func _ready() -> void:
	accept_button.pressed.connect(accepted.emit)
	decline_button.pressed.connect(declined.emit)


func populate(player: Player) -> void:
	nickname_label.text = player.nickname
