extends Node2D

@export var length = 1200
@export var max_reflections = 5
@export var width = 12
@export var color = Color.WHITE

@onready var line: Line2D = $Line2D
@onready var player  = null
var is_reflected: bool

func _ready() -> void:
	player = get_parent()
	line.width = width
	line.default_color = color

func _physics_process(delta: float) -> void:
	if player == null or not player.is_beam_mode():
		line.clear_points()
		return
	var start_global = player.global_position
	var dir = player.aim_dir.normalized()
	var points = [to_local(start_global)]
	
	cast_beam(start_global, dir, max_reflections, points, false)
	line.points = points
	if is_reflected:
		line.default_color = Color(1,0,0)
	else: line.default_color = Color(1,1,1)
	
func cast_beam(start_global: Vector2, dir: Vector2, reflections_left: int, points: Array, is_reflected: bool):
	var end_global = start_global + dir * length
	
	var query := PhysicsRayQueryParameters2D.create(start_global, end_global)
	query.exclude = [player]
	query.collision_mask = 1
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var hit = get_world_2d().direct_space_state.intersect_ray(query)
	
	if !hit:
		points.append(to_local(end_global))
		return
		
	var pos = hit.position
	var col = hit.collider
	var normal = hit.normal
	
	points.append(to_local(pos))
	
	if is_reflected and col.is_in_group("enemy"):
		col.queue_free()
		return
	
	elif col.is_in_group("mirror") and reflections_left > 0:
		var reflect_dir = dir - 2.0 * dir.dot(normal) * normal
		cast_beam(pos, reflect_dir.normalized(), reflections_left -1, points, true)
		return
		
	else:
		#cast on
		var new_start = hit.position + dir * 0.1
		cast_beam(new_start, dir, reflections_left, points, is_reflected)
		return
	
