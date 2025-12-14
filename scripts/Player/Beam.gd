extends Node2D

@export var length = 600
@export var max_reflections = 5
@export var width = 4
@export var color = Color.WHITE

@export var amplitude := 12.0
@export var frequency := 20.0
@export var speed := 5.0
var segments = int(length/5) 
var time = 0.0

@onready var line: Line2D = $CoreLine
@onready var glow_line: Line2D = $GlowLine
@onready var player  = null
var is_reflected: bool

func _ready() -> void:
	player = get_parent()
	line.width = width
	line.default_color = color

func _physics_process(delta: float) -> void:
	time += delta
	
	if player == null or not player.is_beam_mode():
		line.clear_points()
		glow_line.clear_points()
		return
	
	var start_global = player.global_position
	var dir = player.aim_dir.normalized()
	var points = [to_local(start_global)]
	
	cast_beam(start_global, dir, max_reflections, points, false)
	for i in range(points.size()): 
		var p = points[i] 
		var perp = Vector2(-dir.y, dir.x)
		var t = float(i) / (points.size() - 1) 
		var offset = sin(t + frequency + time * speed) * amplitude 
		points[i] = p + perp * offset
		
	line.points = points
	glow_line.points = points
	glow_line.width = width * 2
	glow_line.default_color = line.default_color.lerp(Color(0.3,.07,1.0,0.4), 0.5)
	
func cast_beam(start_global: Vector2, dir: Vector2, reflections_left: int, points: Array, is_reflected: bool):
	var end_global = start_global + dir * length
	if is_reflected:
		line.default_color = Color(1,0,0)
	else:
		line.default_color = Color(1,1,1)
	
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
	
	if is_reflected and col.is_in_group("enemy") and col.is_visible_on_screen:
		PlayerStats.add_points(10)
		print("Reflection burned "+ str(col) +" (+10 points)")
		col.queue_free()
		return
	
	elif col.is_in_group("mirror") and reflections_left > 0:
		var reflect_dir = dir - 2.0 * dir.dot(normal) * normal
		cast_beam(pos, reflect_dir.normalized(), reflections_left -1, points, true)
		return
		
	elif col.is_in_group("environment"): #stop when hit ground
		points.append(to_local(hit.position))
		return
	else:#cast on
		var new_start = hit.position + dir * 0.1
		cast_beam(new_start, dir, reflections_left, points, is_reflected)
		return
