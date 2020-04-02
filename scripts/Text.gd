extends Node

class_name Text

var language = ""
var title = ""
var sentences = []

var autosave = true # save everytime something changes

func _init(text_info):
	language = text_info["Language"]
	title = text_info["Title"]
	for sentence_info in text_info["Sentences"]:
		var new_sentence = Sentence.new(sentence_info)
		sentences.append(new_sentence)
		new_sentence.connect("done", self, "_on_sentence_change")
		new_sentence.connect("reset", self, "_on_sentence_change")
		
#	sentences = text_info["Sentences"]
	
func reset():
	autosave = false # disable autosave to avoid saving for each sentence
	for sentence in sentences:
		sentence.reset()
	save()
	autosave = true
		
func make_filename():
	var fn = title
	var to_remove = ".,/ \\$%"
	for ch in to_remove:
		fn = fn.replace(ch, "")
	return fn.substr(0, 15) + ".json"
		
func make_dict():
	var text_info = {}
	text_info["Title"] = title
	text_info["Language"] = language
	text_info["Sentences"] = []
	for sentence in sentences:
		var sentence_info = sentence.make_dict()
#		sentence_info["Original"] = sentence.original
#		sentence_info["Translation"] = sentence.translation
#		sentence_info["Done"] = sentence.done
		text_info["Sentences"].append(sentence_info)
	return text_info
		
func _on_sentence_change():
	if autosave:
		save()		

func save():
	var saved_texts = File.new()
	var fn = make_filename()
	saved_texts.open("res://saved_texts/" + fn, File.WRITE)
	
	saved_texts.store_string(JSON.print(make_dict()))
	saved_texts.close()
	# TODO: if file exists add a number
		