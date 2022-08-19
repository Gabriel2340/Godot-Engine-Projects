extends ColorRect

var info_and_instructions: String = """(please read all, it takes around 5 minutes)


New (if you had the simulator before, u should read only this):
   Settings:
	  - see dead buildings option is to see how much damage was wasted on the last hit, it could be useful fore some people
	  - deselect books/spells manually, so u can use them in a row
   - explosive robe support added, but because is rng based, it wont be the same as in the game, it's just to have an idea of the possible damage, u can use undo and try them multiple times to see multiple results


Tactics/Spells:
   - you have unlimited spells/tactics
   - the spells levels are saved after u leave the app (you modify the levels the same as the buildings)


Troops proprieties:
   - first you should add your items lvls, troops lvls and then save, after that you can try multiple items and other troops/items without needing to change it to normal before leaving the application
   - the troops pathfinding is wrong, what does it mean: instead of targeting the closest building, sometime they wont target it


Buildings:
   - if you press on the building hp/turns you can change it
   - you can put them on the walls spot and the walls on the buildings spot, it's not a bug, just for fun :)


The items not supported (maybe they are more and some of them could be added later):
   - Fire Bow
   - Dodgy Dagger
   - Defensive Blade
   - Explosive Gloves
   - Revenge Gloves
   - Rage Gauntlet


The items activation:
   - press on the "item activation" button, then press on a troop, when you finish press again on the button
   - ALT + Left click on a troop to activate/deactivate the item ability


Delete a troop/building:
   - CTRL + Left click on a troop to delete it
   - press on the "delete" button, then press on a troop/building, when you finish press again on the button


Undo:
   - Press "undo"/ctrl + z button to go back, you can go back only when you use a spell or a combo (same for redo, ctrl + shift + z)


* if you want to put a goblin/ fire spirit you can add another building and change the hp (that's how it works at the moment, but it wont work fine with the giants, but with the giants you can add goblin storages)
* the app is made to simulate the damage, it wont simulate the changes of items activation, you should do it manually
* if you find any bugs, please dm me so I can solve them
"""

var to_do_list: String = """- adding effects when the buildings are on fire or frozen, when a troop is raged, etc.
- adding books/spells that aren't in the game to use them for fun :)

Not priority ( maybe this wont happen at all )
- see the damage caused by your troops and spells when you hover (you have ctrl + z at the moment)
- making the app for  mobile
- adding attack ability to buildings  and after that adding health to the troops
(what I can't do it's adding animations to the app) 


-----
if you have any suggestions to improve this app you can dm me on discord (gabriel234#9817)
"""

var info_and_instructions_mobile: String = """(please read all, it takes around 5 minutes)


New (if you had the simulator before, u should read only this):
   Settings:
	  - see dead buildings option is to see how much damage was wasted on the last hit, it could be useful fore some people
	  - deselect books/spells manually, so u can use them in a row
   - explosive robe support added, but because is rng based, it wont be the same as in the game, it's just to have an idea of the possible damage, u can use undo and try them multiple times to see multiple results


Tactics/Spells:
   - you have unlimited spells/tactics
   - the spells levels are saved after u leave the app (you modify the levels the same as the buildings)


Troops proprieties:
   - first you should add your items lvls, troops lvls and then save, after that you can try multiple items and other troops/items without needing to change it to normal before leaving the application
   - the troops pathfinding is wrong, what does it mean: instead of targeting the closest building, sometime they wont target it


Buildings:
   - if you press on the building hp/turns you can change it
   - you can put them on the walls spot and the walls on the buildings spot, it's not a bug, just for fun :)


The items not supported (maybe they are more and some of them could be added later):
   - Fire Bow
   - Dodgy Dagger
   - Defensive Blade
   - Explosive Gloves
   - Revenge Gloves
   - Rage Gauntlet


The items activation:
   - press on the "item activation" button, then press on a troop, when you finish press again on the button


Delete a troop/building:
   - press on the "delete" button, then press on a troop/building, when you finish press again on the button


Undo/Redo:
   - Press "undo" button to go back, you can go back only when you use a spell or a combo (same for redo)


* if you want to put a goblin/ fire spirit you can add another building and change the hp (that's how it works at the moment, but it wont work fine with the giants, but with the giants you can add goblin storages)
* the app is made to simulate the damage, it wont simulate the changes of items activation, you should do it manually
* if you find any bugs, please dm me so I can solve them"""


func _on_BackButton_pressed() -> void:
	visible = false




func _on_LicenseButton_pressed() -> void:
	OS.shell_open("https://godotengine.org/license")
