extends Area2D

@export var speed = 8

var direction = Vector2.ZERO
var damage = 0

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))

func _physics_process(delta: float):
	position += direction * speed * delta

	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity
	
func spawn_Bullet(origin: Transform2D, direction: Vector2, damage: int):
	transform = origin
	self.damage = damage
	self.direction = direction
	rotation = direction.angle()
	

func _on_Bullet_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		#GlobalSignals.emit_signal("bullet_impacted", body.global_position, direction)
		body.handle_hit(damage)
		queue_free()
	

