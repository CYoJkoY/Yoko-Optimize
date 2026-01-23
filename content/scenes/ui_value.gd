extends HBoxContainer

onready var label = $Label
onready var icon = $Icon


func _ready()->void :
    label.set_message_translation(false)


func update_value(value: int)->void :
    visible = value
    label.text = str(value)
