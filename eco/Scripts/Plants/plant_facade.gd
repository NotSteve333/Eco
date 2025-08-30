extends Facade
# Visual counterpart to a PlantData
class_name PlantFacade

var plant_data: PlantData

var health_bar: Health
@export var species_data: PlantSpeciesData

# Where the plant is with respect to it's room
@export var room_id: String
@export var position_in_room: Vector2
@export var growth_stage: int
# Grown enough to potentially produce
var mature: bool
	
func write_to_data() -> void:
	plant_data.growth_stage = growth_stage
	plant_data.mature = mature
