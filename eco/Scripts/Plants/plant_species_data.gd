extends Resource
class_name PlantSpeciesData

@export var plant_species_name: String

# Growth Factors

# 0: Water
# 1: Light
# 2: Temp
@export var growth_factors: PackedVector2Array

# 3: Polination
@export var self_polinated: bool
# How resistent is the plant to wind
@export var rigidity: float
@export var base_growth_chance: float
@export var base_spread_chance: float
@export var spread_radius: float
@export var surface_type: PlantUtils.SurfaceType

@export var total_stages: int
# Growth stage range in which this plant fruits
@export var mature_range: Vector2i
# Paths to sprites for each growth stage
@export var spritesheet: String
