extends Node2D
class_name Plant

@export var species_data: PlantSpeciesData

# Number of factors influencing growth chance
const num_growth_factors = 3

# Identifies plant instance
var plant_id: int
# Environmental conditions, as they pertain to this species
var growth_conditions: PackedFloat64Array
# Average of all environmental conditions
var growth_chance: float
# Current level of growth
var growth_stage: int
# Able to grow this tick
var can_grow: bool
# Able to propogate
var can_spread: bool
# Grown enough to potentially produce
var mature: bool

signal spread(can_spread: bool)

# Attempts to up the stage based on current conditions and the random value this tick. 
# Checks if the plant is eligable to spread this tick
func update_plant(n: int) -> void:
	if can_grow:
		var growth_updates = MathUtil.binomial_dist(n, growth_chance)
		grow(growth_updates)
	if mature:
		var spread_updates = MathUtil.binomial_dist(n, growth_conditions[num_growth_factors])

func get_num_successes(n: int, rand_val: float, p: float) -> int:
	var np = n * p
	var npq = np * (1 - p)
	return MathUtil.normal_dist(rand_val, np, npq)

func grow(stage: int) -> void:
	growth_stage = max(growth_stage + stage, species_data.total_stages)
	if growth_stage >= species_data.mature_stage:
		mature = true
	if growth_stage >= species_data.total_stages:
		can_grow = false

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
