extends Area2D

@export var speed = 8

var direction = Vector2.ZERO

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))

func _physics_process(delta: float):
	position += direction * speed * delta

	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity
	
func set_direction(origin: Vector2, direction: Vector2):
	if (direction.x == 0 && direction.y == 0):
		direction = Vector2(-1,0)
		
	self.direction = (origin - direction).normalized()
	rotation = direction.angle()

func _on_Bullet_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		GlobalSignals.emit_signal("bullet_impacted", body.global_position, direction)
		body.handle_hit()
		queue_free()
	

