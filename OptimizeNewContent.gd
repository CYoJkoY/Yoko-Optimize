extends "res://mods-unpacked/Yoko-NewContentLoader/NewContent.gd"

var gmo_characters: Array = []

# =========================== Extension =========================== #
func duplicate(subresources:=false) -> Resource:
    var duplication =.duplicate(subresources)
    duplication.gmo_characters = gmo_characters.duplicate()

    return duplication

func add_custom_resources() -> void:
    .add_custom_resources()
    gmo_characters = ProgressData.op_update_runtime_gmo_characters()
    add_if_not_null(ItemService.items, gmo_characters)

func remove_custom_resources() -> void:
    .remove_custom_resources()
    gmo_characters = ProgressData.op_update_runtime_gmo_characters()
    erase_if_not_null(ItemService.items, gmo_characters)
