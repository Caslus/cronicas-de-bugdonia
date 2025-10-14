extends GridContainer

@export var gridColumns: int = 5
@export var cellCount: int = 25
@export var cellSize: int = 150
@export var labelFontSize: int = 24
@export var cellScene: PackedScene

func clear() -> void:
    for child in get_children():
        child.queue_free()


func createCells() -> void:
    for i in range(cellCount):
        var cell: PanelContainer = cellScene.instantiate()
        cell.name = "Cell_%d" % i
        cell.custom_minimum_size = Vector2(cellSize, cellSize)
        var label: Label = cell.get_node("Label")
        if label:
            label.text = "[%d][%d]" % [i / gridColumns, i % gridColumns]
            label.add_theme_font_size_override("font_size", labelFontSize)
        add_child(cell)

func _ready() -> void:
    self.columns = gridColumns
    clear()
    createCells()