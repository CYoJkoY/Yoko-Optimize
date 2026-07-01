class_name ItemCharacterData
extends ItemData

export(Array, String) var wanted_tags
export(Array, String) var banned_item_groups
export(Array, String) var banned_items
export(Array, String) var banned_upgrades
export(Array, Resource) var starting_weapons
export(Array, Resource) var starting_items

func clone(character: CharacterData) -> void:
    my_id = "item_" + character.my_id
    my_id_hash = Keys.generate_hash(my_id)
    is_locked = character.is_locked
    unlocked_by_default = character.unlocked_by_default
    can_be_looted = character.can_be_looted
    icon = character.icon
    name = character.name
    tier = character.tier
    value = character.value
    effects = character.effects
    tracking_text = character.tracking_text
    is_lockable = character.is_lockable
    unlock_codex_descr_after_get_it = character.unlock_codex_descr_after_get_it
    is_cursed = character.is_cursed
    curse_factor = character.curse_factor
    max_nb = character.max_nb
    item_appearances = character.item_appearances
    tags = character.tags
    replaced_by = character.replaced_by
    wanted_tags = character.wanted_tags
    banned_item_groups = character.banned_item_groups
    banned_items = character.banned_items
    banned_upgrades = character.banned_upgrades
    starting_weapons = character.starting_weapons
    starting_items = character.starting_items

func get_category() -> int:
	return Category.ITEM
