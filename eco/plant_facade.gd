extends AnimatedSprite2D
# Visual counterpart to a PlantData
class_name PlantFacade

var plant_data: PlantData

var health_bar: Health

# Current level of growth
var growth_stage: int
# Grown enough to potentially produce
var mature: bool

func _init(data: PlantData) -> void:
	plant_data = data
	
func write_to_data() -> void:
	plant_data.growth_stage = growth_stage
	plant_data.mature = mature
