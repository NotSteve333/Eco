extends Resource
class_name PlantSpeciesData

var plant_species_name: String

#Growth Factors

# 0: Water
# 1: Light
# 2: Temp
var growth_factors: PackedVector2Array

# 3: Polination
var self_polinated: bool

var base_growth_chance: float
var base_spread_chance: float
var surface_type: PlantUtils.SurfaceType

var total_stages: int
var mature_range: Vector2i
var sprites: Array[Sprite2D]
