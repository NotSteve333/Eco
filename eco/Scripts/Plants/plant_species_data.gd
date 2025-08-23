extends Resource
class_name PlantSpeciesData

var plant_species_name: String

# Growth Factors

# 0: Water
# 1: Light
# 2: Temp
var growth_factors: PackedVector2Array

# 3: Polination
var self_polinated: bool
# How resistent is the plant to wind
var rigidity: float
var base_growth_chance: float
var base_spread_chance: float
var spread_radius: float
var surface_type: PlantUtils.SurfaceType

var total_stages: int
# Growth stage range in which this plant fruits
var mature_range: Vector2i
# Paths to sprites for each growth stage
var sprites: Array[String]
