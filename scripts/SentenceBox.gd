extends PanelContainer

signal done

onready var original_label = find_node("OriginalSentence")
onready var translation_box = find_node("UserTranslation")
onready var hintbutton = find_node("HintButton")

var original = ""
var translation = ""

var done = false
var next_sentence_box = null

func set_sentence(_original, _translation, done=false):
	original = _original
	translation = _translation
	original_label.text = translation
	translation_box.rect_size.y = original_label.rect_size.y
	
	if done:
		translation_box.text = original
		on_completion()
	
func _on_text_changed():
	var user_translation = translation_box.text
	if user_translation == "":
		find_node("Indicator").text = ""
		
	elif user_translation == original:
		on_completion()
	else:
		if user_translation == original.substr(0,len(user_translation)):
			find_node("Indicator").text = "OK"
		else:
			find_node("Indicator").text = "NOK"
			
func on_completion():
		find_node("Indicator").text = "Done!"
		translation_box.readonly = true
		hintbutton.disabled = true
		done = true
		emit_signal("done")
		if next_sentence_box != null:
			next_sentence_box.grab_focus()
		
func grab_focus():
	translation_box.grab_focus()
	
func set_focus_next(_next_sentence_box):
	next_sentence_box = _next_sentence_box
	translation_box.set_focus_next(next_sentence_box.get_path())


func _on_HintButton_pressed():
#	var user_translation = translation_box.text
	var correct = 0
	for c in translation_box.text:
		if c == original[correct]:
			correct += 1
	translation_box.text = original.substr(0, correct+1)

