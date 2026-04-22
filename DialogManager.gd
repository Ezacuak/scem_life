class_name DialogManager
extends Resource

var dialogs # Contains the actor's dialogs
var current_dialog
var choices

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(actorName, p_choices):
	choices = p_choices
	
	# load file
	var file = FileAccess.open("res://dialogs/" + actorName +".json", FileAccess.READ)
	var file_content = file.get_as_text()
	
	# json to dict
	var json = JSON.new()
	var error = json.parse(file_content)
	if error == OK:
		var data_received = json.data
		if (typeof(data_received) == TYPE_DICTIONARY) and ("dialogs" in data_received) and ("starting_dialog" in data_received):
			dialogs = data_received["dialogs"];
			current_dialog = data_received["starting_dialog"];
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", file_content, " at line ", json.get_error_line())

func get_current_dialog():
	return current_dialog
	
	
func choice_is_available(choice, requirements):
	var isAvailable = true
	var N = len(requirements)
	var i = 0
	
	while (i < N && isAvailable): # check every requirement
		var requirement = requirements[i]
		var name = requirement["name"]
		var value = requirement["value"]
		
		if (not name in choices) or (value != choices[name]): # requirement
			isAvailable = false
		
		i += 1
	
	return isAvailable

func get_available_answers():
	if (current_dialog == null):
		return []
		
	var answers = []
		
	for choice in dialogs[current_dialog]:
		if ( choice_is_available(choice, choice["requirements"])):
			answers.append(choice["text"])
			
	return answers
	
	
func get_choice(choiceText):
	if current_dialog == null:
		return []
	
	var dialog = dialogs[current_dialog]
	var N = len(dialog)
	var i = 0
	
	while i < N and dialog[i]["text"] != choiceText:
		i += 1
	
	if i == N:
		printerr("Choice not in dialog...")
		return null
	
	return dialog[i]
	
func choose_dialog(choiceText):
	# Returns True if it's possible, false otherwise	
	var choice = get_choice(choiceText)

	if (choice != null and choice_is_available(choice, choice["requirements"])):
		for impact in choice["impacts"]:
			choices[impact["name"]] = impact["value"]
		current_dialog = choice["nextDialog"]
