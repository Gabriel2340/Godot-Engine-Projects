extends VBoxContainer

signal troop_proprieties_changed


onready var n_troop_lvl := $TroopLvl/Lvl
onready var n_troop := $ChooseTroop/Troop
onready var n_item := $Item/Item
onready var n_item_lvl := $ItemLvl/Lvl
onready var n_rune_lvl := $RuneLvl/Lvl

var troops_names: Array = ["Archer", 
		"Barbarian", 
		"Wizard",
		"Prince",
		"Giant",
		"Goblin",
		"P.E.K.K.A",
		"Bomber",
		"Baby Dragon",
		"Minion",
		"Bomb Miner"]


var troops: Dictionary = {"Archer" : {"items" : ["Fire Bow", "Quick Bow", "Strong Bow"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Barbarian" : {"items" : ["Heavy Sword", "Guarding Sword", "Rage Sword"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Wizard" : {"items" : ["Fire Robe", "Explosive Robe", "Armor Robe"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Prince" : {"items" : ["Twofold Lance", "Power Lance", "Shield Lance"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Giant" : {"items" : ["Rage Gauntlet", "Power Gauntlet", "Healing Gauntlet"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Goblin" : {"items" : ["Triple Dagger", "Fury Dagger", "Dodgy Dagger"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"P.E.K.K.A" : {"items" : ["Lightning Blade", "Defensive Blade", "Dual Blade"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Bomber" : {"items" : ["Ice Bomb", "Heavy Bomb", "Rage Bomb"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Baby Dragon" : {"items" : ["Scattering Collar", "Fire Collar", "Force Collar"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Minion" : {"items" : ["Explosive Gloves", "Revenge Gloves", "Double Gloves"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4},
		"Bomb Miner" : {"items" : ["Fire Bomb", "Charging Bomb", "Zap Bomb"], "lvl" : 10, "items_lvl" : [4, 4, 4], "item" : 0, "rune_lvl" : 4}
		}


func _ready() -> void:
	add_items_to_option_lists()


func add_items_to_option_lists():
	for i in range(1, 11):
		n_troop_lvl.add_item(str(i))
	for name in troops_names:
		n_troop.add_item(name)
	add_items_to_item_list("Archer")
	for i in range(5):
		n_item_lvl.add_item(str(i))
	for i in range(5):
		n_rune_lvl.add_item(str(i))


func add_items_to_item_list(troop):
	n_item.clear()
	for i in range(3):
		n_item.add_item(troops[troop]["items"][i])


func on_troop_changed(new_troop):
	n_troop_lvl.select(troops[new_troop]["lvl"] - 1)
	add_items_to_item_list(new_troop)
	n_item_lvl.select(troops[new_troop]["items_lvl"][troops[new_troop]["item"]])
	n_rune_lvl.select(troops[new_troop]["rune_lvl"])
	n_item.select(troops[new_troop]["item"])


func _on_Troop_item_selected(index: int) -> void:
	var new_troop : String = troops_names[index]
	on_troop_changed(new_troop)


func _on_Lvl_item_selected(index: int) -> void:
	var level : int = index + 1
	troops[n_troop.text]["lvl"] = level
	emit_signal("troop_proprieties_changed")


func _on_Item_item_selected(index: int) -> void:
	n_item_lvl.select(troops[n_troop.text]["items_lvl"][index])
	troops[n_troop.text]["item"] = index
	emit_signal("troop_proprieties_changed")


func get_item_index(item: String) -> int:
	for i in troops:
		for j in range(3):
			if troops[i]["items"][j] == item:
				return j
	return 20

func _on_ItemLvl_item_selected(item_lvl: int) -> void:
	troops[n_troop.text]["items_lvl"][troops[n_troop.text]["items"].find(n_item.text)] = item_lvl
	emit_signal("troop_proprieties_changed")


func _on_rune_lvl_selected(rune_lvl: int) -> void:
	troops[n_troop.text]["rune_lvl"] = rune_lvl
	emit_signal("troop_proprieties_changed")
