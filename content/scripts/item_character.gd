class_name ItemCharacterData
extends CharacterData

func clone(character: CharacterData) -> void:
    my_id = character.my_id
    my_id_hash = character.my_id_hash
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
