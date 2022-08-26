extends Control

onready var itemList = get_node("HBoxContainer/ItemList")

var powersPath= "res://Scenes/Powers/"

var levelData = "res://Scripts/LevelData.txt"

onready var globalVars = get_node("/root/GlobalVars")


var selectedItem = null
var items = []
var itemCounts = []

func _ready() -> void:
	globalVars.start = false
	loadPowers(powersPath)
	setInventory()
	
func _process(_delta: float) -> void:
	if !globalVars.start:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if selectedItem ==null:
				var pos = itemList.get_local_mouse_position()
				var item = itemList.get_item_at_position(pos, true)
				
				if item >= 0:
					selectedItem = spawnItem(item)
					selectedItem.selected = true
		else:
			if selectedItem != null:
				selectedItem.selected = false
				selectedItem = null

func loadPowers(path):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			var powerScene = load(path + file)
			var powerInstance = powerScene.instance()
			items.append(powerInstance)

func setInventory():
	var text = load_text_file(levelData)
	var lines = text.split("\n", false)
	for line in lines:
		var cols = line.split(" ")
		if cols[0] == get_tree().current_scene.name:
			itemCounts.append(int(cols[1]))
			itemCounts.append(int(cols[2]))
			itemCounts.append(int(cols[3]))
		else:
			continue
	for i in range(items.size()):
		var itemSprite = items[i].get_node("AnimatedSprite")
		if itemCounts[i] != 0:
			itemList.add_item(str(itemCounts[i]), itemSprite.get_sprite_frames().get_frame("default", 0), true)
#			itemList.set_item_icon_region(i, itemSprite.get_sprite_frames().get_frame("default", 0).region_rect)
		else:
			itemList.add_item("", null, false)
#			itemList.set_item_icon_region(id, itemSprite.region_rect)
			
		
func spawnItem(itemIndex: int):
	var newItem = items[itemIndex].duplicate()
	if(itemCounts[itemIndex] == 1):
		items.remove(itemIndex)
		itemCounts.remove(itemIndex)
		itemList.remove_item(itemIndex)
	else:
		itemCounts[itemIndex] -= 1
		itemList.set_item_text(itemIndex, str(itemCounts[itemIndex]))
	
	var parentNode = get_parent()
	parentNode.add_child(newItem, true)
	
	return newItem
	
func load_text_file(path):
	var f = File.new()
	var err = f.open(path, File.READ)
	if err != OK:
		var error = "Could not open file \"" + path + "\""
		if err == ERR_FILE_NOT_FOUND:
			error += ", File not found"
		else:
			error += ", error code " + str(err)
		OS.alert(error, "Error opening level file")
		return null
	var text = f.get_as_text()
	f.close()
	return text
	
func _on_Play_pressed():
	
	globalVars.start = true
	get_node("Buttons/Play").disabled = true

func _on_Reset_pressed():
	globalVars.reset = true
	globalVars.start = false
	get_node("Buttons/Play").disabled = false
	var _result = get_tree().reload_current_scene()
	globalVars.reset = false
	
