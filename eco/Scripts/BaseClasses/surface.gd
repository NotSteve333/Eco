extends ConvexPolygonShape2D
# Base class for surfaces which hold EnCons and Plants can grow on
class_name Surface

@export var water: float
@export var light: float
@export var temp: float
@export var type: PlantUtils.SurfaceType


func get_type() -> PlantUtils.SurfaceType:
	return type

func get_singe_condition(index: int) -> float:
	match index:
		0:return water
		1: return light
		2: return temp
	return 0.0
	
func get_all_conditions() -> Vector3:
	return Vector3(water, light, temp)
	
func contains_point(pos: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(pos, points)
