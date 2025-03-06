extends VBoxContainer

func get_variables():
	var properties = []

	var selected = SelectedManager.selected;

	if selected == null:
		return properties

	for property in selected.get_property_list():
		if property.get("name").begins_with("VAR_"):
			properties.append(property)
	return properties

func create_editor_header(selected):
	var labelContainer = HBoxContainer.new()
	labelContainer.alignment = HBoxContainer.AlignmentMode.ALIGNMENT_CENTER
	add_child(labelContainer)

	var labelName = Label.new()
	if (selected.get_meta("objectName") != null):
		labelName.text = selected.get_meta("objectName")
	else:
		labelName.text = "Object"
	labelName.size_flags_horizontal = Control.SIZE_EXPAND_FILL | Control.SIZE_FILL
	labelContainer.add_child(labelName)

	var close_button = Button.new()
	close_button.text = "X"
	close_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	close_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	labelContainer.add_child(close_button)

func create_float_editor(selected, container, prop):
		var value = Label.new()
		value.text = str(selected.get(prop.name))
		container.add_child(value)

		var buttonMinus = Button.new()
		buttonMinus.text = "-"
		buttonMinus.connect("pressed", Callable(self, "_on_button_pressed").bind(prop.name, -1, value))
		container.add_child(buttonMinus)

		var buttonPlus = Button.new()
		buttonPlus.text = "+"
		buttonPlus.connect("pressed", Callable(self, "_on_button_pressed").bind(prop.name, 1, value))
		container.add_child(buttonPlus)

func create_int_editor(selected, container, prop):
		var value = Label.new()
		value.text = str(selected.get(prop.name))
		container.add_child(value)

		var buttonMinus = Button.new()
		buttonMinus.text = "-"
		buttonMinus.connect("pressed", Callable(self, "_on_button_pressed").bind(prop.name, -1, value))
		container.add_child(buttonMinus)

		var buttonPlus = Button.new()
		buttonPlus.text = "+"
		buttonPlus.connect("pressed", Callable(self, "_on_button_pressed").bind(prop.name, 1, value))
		container.add_child(buttonPlus)

func create_string_editor(selected, container, prop):
		var value = LineEdit.new()
		value.text = selected.get(prop.name)
		value.connect("text_changed", Callable(self, "_on_text_changed").bind(prop.name))
		container.add_child(value)

func create_boolean_editor(selected, container, prop):
		var value = Label.new()
		value.text = str(selected.get(prop.name)).to_upper()
		container.add_child(value)

		var buttonPlus = Button.new()
		buttonPlus.text = "Toggle"
		buttonPlus.connect("pressed", Callable(self, "_on_toggle_button_pressed").bind(prop.name, value))
		container.add_child(buttonPlus)

func create_ui():
	for child in get_children():
		remove_child(child)

	var selected = SelectedManager.selected;
	var properties = get_variables()

	if properties.size() == 0:
		return

	create_editor_header(selected)
	
	for prop in properties:
		var container = HBoxContainer.new()
		add_child(container)

		var label = Label.new()
		label.text = prop.name.replace("VAR_", "") + ":"
		container.add_child(label)

		if prop.type == TYPE_FLOAT:
			create_float_editor(selected, container, prop)
		elif prop.type == TYPE_INT:
			create_int_editor(selected, container, prop)
		elif prop.type == TYPE_STRING:
			create_string_editor(selected, container, prop)
		elif prop.type == TYPE_BOOL:
			create_boolean_editor(selected, container, prop)
			
func _on_close_button_pressed():
		SelectedManager.set_selected(null)

func _on_button_pressed(prop_name, change, value_label):
		var selected = SelectedManager.selected
		var current_value = selected.get(prop_name)
		if Input.is_key_pressed(KEY_SHIFT):
			change *= 10
		elif Input.is_key_pressed(KEY_CTRL) and typeof(current_value) == TYPE_FLOAT:
			if change > 0:
				change = 0.5
			else:
				change = -0.5
		current_value += change
		SelectedManager.edit_number(prop_name, current_value)
		value_label.text = str(current_value)

func _on_text_changed(new_text, prop_name):
		SelectedManager.edit_string(prop_name, new_text)

func _on_toggle_button_pressed(prop_name, value_label):
		var selected = SelectedManager.selected
		var current_value = selected.get(prop_name)
		current_value = !current_value
		SelectedManager.edit_boolean(prop_name, current_value)
		value_label.text = str(current_value).to_upper()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_ui()
	SelectedManager.selected_changed.connect(create_ui)
