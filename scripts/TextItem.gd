extends HBoxContainer

signal chosen
var text
onready var flag = find_node("Flag")

func load_text_info(text_info):
	text = Text.new(text_info)
	find_node("OriginalLanguage").text = text.language
	find_node("TextTitle").text = text.title
	var sentence_num = len(text.sentences)
	find_node("SentenceNumber").text = "%s sentences" % sentence_num

	find_node("Flag").texture = load("res://flags/%s.png" % text.language)
	

func _on_ContinueButton_pressed():
	emit_signal("chosen", text)


func _on_ResetButton_pressed():
#	for sentence_num in range(len(text.sentences)):
#		text.sentences[sentence_num]["Done"] = false
	text.reset()
#	emit_signal("reset", text)
	emit_signal("chosen", text)
	
#func load_text_info(_text_info):
#	text_info = _text_info
#	find_node("OriginalLanguage").text = text_info["Language"]
#	find_node("TextTitle").text = text_info["Title"]
#	var sentence_num = len(text_info["Sentences"])
#	find_node("SentenceNumber").text = "%s sentences" % sentence_num
#
#	find_node("Flag").texture = load("res://flags/%s.png" % text_info["Language"])


#func _on_ContinueButton_pressed():
#	emit_signal("chosen", text_info)
#
#
#func _on_ResetButton_pressed():
#	for sentence_num in range(len(text_info["Sentences"])):
#		text_info["Sentences"][sentence_num]["Done"] = false
#	emit_signal("reset", text_info)
#	emit_signal("chosen", text_info)
