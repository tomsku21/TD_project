extends Node
@export var animation_tree: AnimationTree
@export var character: Enemy
var lastpos: Vector2
func _ready():
	lastpos = character.global_position

func _physics_process(delta: float) -> void:
	var direction = lastpos.direction_to(character.global_position)
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/blend_position", direction)
	lastpos = character.global_position
