class_name AssetLoader
extends RefCounted
## Tries hero GLB first, then MeshKit CSG.
## Drop `assets/characters/<id>/<id>.glb` to replace the silhouette.

static func try_glb(root: Node3D, id: String) -> bool:
	var path := "res://assets/characters/%s/%s.glb" % [id, id]
	if not ResourceLoader.exists(path):
		path = "res://assets/characters/%s/%s.gltf" % [id, id]
	if not ResourceLoader.exists(path):
		return false
	var packed := load(path)
	if packed == null:
		return false
	var inst: Node = packed.instantiate() if packed is PackedScene else packed
	if inst == null:
		return false
	MeshKit.clear(root)
	root.add_child(inst)
	return true

static func apply_playable(root: Node3D, id: String) -> void:
	if try_glb(root, id):
		return
	MeshKit.apply_playable(root, id)

static func apply_enemy(root: Node3D, id: String) -> void:
	if try_glb(root, id):
		return
	if not MeshKitExt.apply_enemy(root, id):
		MeshKit.apply_enemy(root, id)
