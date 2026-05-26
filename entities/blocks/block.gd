class_name Block
extends Entity


func _ready() -> void:
	_setup()
	
	
func _setup():
	super()


func _on_hitbox_hit():
	if HealthComp:
		HealthComp.damage(1.0)


func _on_health_damaged():
	var tween = create_tween()
	tween.tween_property(self, "modulate:v", modulate.v - modulate.v, 0.15)
	tween.tween_property(self, "modulate:v", modulate.v, 0.1)
