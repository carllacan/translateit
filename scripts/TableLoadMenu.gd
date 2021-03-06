extends VBoxContainer

signal done(next_window, result)


const SAVED_TABLES_DIR = "res://saved_tables/"
var TextItem = load("res://scenes/TextItem.tscn")
onready var text_list = find_node("TextList")

#func _ready():
#	connect("visibility_changed", self, "_on_visibility_change")
		
func enter():
	load_saved_texts()
	show()
	
func exit():
	hide()
	for text_box in text_list.get_children():
		text_list.remove_child(text_box)
		
func _on_CancelButton_pressed():
	emit_signal("done", "MainMenuWindow", null)

func load_saved_texts():
	var load_dir = Directory.new()
	load_dir.open(SAVED_TABLES_DIR)
	load_dir.list_dir_begin(true, true)
	
	print("Getting saved texts...")
	while true:
		var filename = load_dir.get_next()

		if filename == "": # this signals the end of the directory
			break
		if filename.ends_with(".json"):
			var file = File.new()
			file.open(SAVED_TABLES_DIR + filename, file.READ)
			var json_result = JSON.parse(file.get_as_text())
			file.close()
			
			if json_result.error != OK:
				print("Error while parsing file " + filename)
				continue
			var table_info = json_result.result
			
			var new_ti = TextItem.instance()
			text_list.add_child(new_ti)
			new_ti.load_table_info(table_info)
			new_ti.connect("chosen", self, "_on_table_choice")

	
func _on_table_choice(table_info):
#	emit_signal("table_chosen", text_info)
	emit_signal("done", "TablePlayWindow", table_info)

func _on_SortByLangButton_pressed():
	sort_by_language()
	
func _on_SortByPlayedButton_pressed():
	sort_by_lastplayed(false)

func _on_SortByCreated_pressed():
	sort_by_created(false)

func _on_SortByProgress_pressed():
	sort_by_progress(false)

func sort_by_language():
	var text_boxes = []
	for child in text_list.get_children():
		text_list.remove_child(child)
		text_boxes.append(child)

	for lang in Globals.LANGUAGES:
		for tb in text_boxes:
			if tb.text.language == lang:
				text_list.add_child(tb)

func sort_by_created(last_first=false):
	var text_boxes = []
	for child in text_list.get_children():
		text_list.remove_child(child)
		text_boxes.append(child)

	text_boxes.sort_custom(Globals, "compare_text_box_creation_dates")
	for tb in text_boxes:
		text_list.add_child(tb)
		
func sort_by_lastplayed(last_first=false):
	var text_boxes = []
	for child in text_list.get_children():
		text_list.remove_child(child)
		text_boxes.append(child)

	text_boxes.sort_custom(Globals, "compare_text_box_lastplayed_dates")
	for tb in text_boxes:
		text_list.add_child(tb)

func sort_by_progress(last_first=false):
	var text_boxes = []
	for child in text_list.get_children():
		text_list.remove_child(child)
		text_boxes.append(child)

	text_boxes.sort_custom(Globals, "compare_text_box_progress")
	for tb in text_boxes:
		text_list.add_child(tb)

