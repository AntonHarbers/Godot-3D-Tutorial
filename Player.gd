extends KinematicBody

signal hit

export var speed = 10
export var fall_acceleration = 75

export var jump_impulse = 20
export var bounce_impulse = 15

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
		
	if direction != Vector3.ZERO :
		direction = direction.normalized()
		$Pivot.look_at(transform.origin + direction, Vector3.UP)
	
	
	target_velocity.x = direction.x * speed;
	target_velocity.z = direction.z * speed;
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider == null:
			continue
		
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			
			if Vector3.UP.dot(collision.normal) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break
		
	move_and_slide(target_velocity, Vector3.UP)


func die():
	emit_signal("hit")
	queue_free()

func _on_MobDetector_body_entered(body):
	die()
