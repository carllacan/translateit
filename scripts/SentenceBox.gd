extends HBoxContainer

signal done
signal reset
signal grabbed_focus

onready var sentence_container = find_node("SentenceContainer")
onready var original_label = find_node("OriginalSentence")
onready var translation_box = find_node("UserTranslation")
onready var nextbutton = find_node("NextButton")
onready var resetbutton = find_node("ResetButton")
onready var buttons = find_node("Buttons")
onready var dummy = find_node("Dummy")

var BaseStyle = load("res://theme/panelstyle.tres")
var WrongStyle = load("res://theme/panelwrongstyle.tres")
var DoneStyle = load("res://theme/paneldonestyle.tres")

var sentence = null
var original = ""
var translation = ""
var done = false

var next_sentence_box = null # TODO: use signals for all this

func set_sentence(_sentence):
	sentence = _sentence

	original = sentence.original
	translation = sentence.translation
	done = sentence.done
	original_label.text = translation
	translation_box.rect_size.y = original_label.rect_size.y

	if done:
		translation_box.text = original
		on_completion()
		
#func set_sentence(_original, _translation, done=false):
#	original = _original
#	translation = _translation
#	original_label.text = translation
#	translation_box.rect_size.y = original_label.rect_size.y
#
#	if done:
#		translation_box.text = original
#		on_completion()
	
func _on_text_changed():
	translation_box.center_viewport_to_cursor()
	var user_translation = translation_box.text
		
	if user_translation == original:
		on_completion()
	else:
		if user_translation == original.substr(0,len(user_translation)):
			find_node("Indicator").text = "OK"
			sentence_container.add_stylebox_override("panel",BaseStyle)
		else:
			find_node("Indicator").text = "NOK"
			sentence_container.add_stylebox_override("panel",WrongStyle)
			
	

func on_completion():
	find_node("Indicator").text = "Done!"
	sentence_container.add_stylebox_override("panel",DoneStyle)
	translation_box.readonly = true

	hide_buttons()
	done = true
		
	emit_signal("done")
	if next_sentence_box != null: # TODO: do this as a response to the signal
		next_sentence_box.grab_focus()
			
	sentence.mark_done()
			
		
func grab_focus():
	translation_box.grab_focus()
	
func has_focus():
	return translation_box.has_focus()
	
func set_focus_next(_next_sentence_box):
	next_sentence_box = _next_sentence_box
	translation_box.set_focus_next(next_sentence_box.translation_box.get_path()) # useless?
	
func get_correct_characters():
	var correct = 0
	for c in translation_box.text:
		if c == original[correct]:
			correct += 1
	return correct
	
func _on_HintButton_pressed():
	show_hint()
	
func show_hint():
	translation_box.text = original.substr(0, get_correct_characters()+1)
	translation_box.grab_focus()
	translation_box.cursor_set_column(len(translation_box.text), true)
	_on_text_changed() # manually changing the text does not trigger the signal, I have to call this manually
	
func _input(event):
	if event.is_action_pressed("next"):
		if translation_box.has_focus():
			show_hint()
#	if event.is_action_pressed("ui_focus_next") and has_focus():
#		if next_sentence_box != null:
#			next_sentence_box.grab_focus()
#		get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_accept") and has_focus(): # handle input
		get_tree().set_input_as_handled()
			
func _on_ResetButton_pressed():
	reset()
	
func reset():
	translation_box.text = ""
	emit_signal("reset")
	grab_focus()

func hide_buttons():
	buttons.hide()
	dummy.show()
	
func show_buttons():
	dummy.hide()
	buttons.show()

func _on_UserTranslation_focus_entered():
	if not done:
		show_buttons()
	emit_signal("grabbed_focus")

#func _on_UserTranslation_focus_exited():
#	hide_buttons()
	
func _when_other_sentence_grabs_focus():
	if not translation_box.has_focus():
		hide_buttons()
