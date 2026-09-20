class_name WorldPalette
extends Node
## Paints CSG world pieces to the Veil of Ash material target.

@export var apply_on_ready: bool = true

func _ready() -> void:
	if apply_on_ready:
		apply_to_tree(self.get_parent())

static func apply_to_tree(root: Node) -> void:
	var stone := MeshKit.mat(Color(0.13, 0.12, 0.12), 0.08, 0.78)
	var wet := MeshKit.mat(Color(0.10, 0.10, 0.11), 0.22, 0.42)
	_paint(root, stone, wet)

static func _paint(n: Node, stone: Material, wet: Material) -> void:
	if n is CSGBox3D:
		var box := n as CSGBox3D
		box.material = wet if box.size.y <= 1.2 else stone
	elif n is CSGCylinder3D or n is CSGSphere3D or n is CSGTorus3D:
		(n as CSGPrimitive3D).material = stone
	for c in n.get_children():
		_paint(c, stone, wet)
