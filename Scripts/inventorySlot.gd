class_name InventorySlot
var item
var amount: int

func _init(_item = null, _amount := 0):
	item = _item
	amount = _amount

func is_empty() -> bool:
	return item == null
