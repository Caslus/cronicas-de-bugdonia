extends Control

@export var titleLabel: Label
@export var arrayList: VBoxContainer

func updateArray(arr: Array) -> void:
	for child in arrayList.get_children():
		child.queue_free()
	for i in range(arr.size()):
		var itemLabel = Label.new()
		itemLabel.text = str("[%d]: %s" % [i, str(arr[i])])
		arrayList.add_child(itemLabel)

func setup(selected: Node, prop) -> void:
	var formatName = selected.name + " - " + prop.name.replace("VAR_", "")
	titleLabel.text = formatName
	for child in arrayList.get_children():
		child.queue_free()
	
	var arr = selected.get(prop.name)
	updateArray(arr)

	selected.connect("valuesChanged", Callable(self, "updateArray").bind(selected.get(prop.name)))

func _on_close_button_pressed() -> void:
	queue_free()
