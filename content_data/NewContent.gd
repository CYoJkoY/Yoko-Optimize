extends Resource

# ItemService
export (Array, Resource) var stats = null

func add_resources() -> void:
    add_if_not_null(ItemService.stats, stats)
    
    ItemService.init_unlocked_pool()

func add_if_not_null(array, _items) -> void:
    if _items != null: array.append_array(_items)
