extends Node2D
# Specific instance of a plant
class_name Plant

# Data storing specific data about the species this plant belongs to
@export var species_data: PlantSpeciesData

# Number of factors influencing growth chance
const num_growth_factors = 3

# Identifies plant instance
var plant_id: int
# Last time when this plant was update. Determines number of ticks to process
var last_update: float
# Environmental conditions, as they pertain to this species
var growth_conditions: PackedFloat64Array
# Average of all environmental conditions
var growth_chance: float
# Current level of growth
var growth_stage: int
# Able to grow this tick
var can_grow: bool
# Grown enough to potentially produce
var mature: bool

# Ticks that have succeeded a spread
signal spread(num_spreads: int, species: String)
signal die(location: Vector2)

# Simulates n number of ticks.
# TO FIX: include large scale/historic factors
func update_plant(n: int) -> void:
	var growth_updates = MathUtil.binomial_dist(n, growth_chance)
	grow(growth_updates)
	if mature:
		var spread_updates = MathUtil.binomial_dist(n, growth_conditions[num_growth_factors])
		spread.emit(spread_updates, species_data.plant_species_name)

# Grow the appropriate number of stages
func grow(stages: int) -> void:
	growth_stage = max(growth_stage + stages, species_data.total_stages)
	if growth_stage >= species_data.mature_stage:
		mature = true
	if growth_stage >= species_data.total_stages:
		die.emit(position)

# 0: Water
# 1: Light
# 2: Temp
# 3: Polination

# Computes the overall conditions
func compute_growth_factor(environment: PackedFloat64Array) -> float:
	growth_chance = 0.0
	growth_chance = MathUtil.average(growth_conditions.slice(0, num_growth_factors))
	return growth_chance * species_data.base_growth_chance
	
# Computes the quality of a single condition
func compute_single_condition(cond_num: int, val: float) -> float:
	var mean = species_data.growth_factors[cond_num][0]
	var sig = species_data.growth_factors[cond_num][1]
	var new_cond_val = MathUtil.normal_dist(val, mean, sig)
	growth_conditions[cond_num] = new_cond_val
	return new_cond_val
