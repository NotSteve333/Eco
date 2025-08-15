extends Node2D
# Specific instance of a plant
class_name Plant

# Data storing specific data about the species this plant belongs to
@export var species_data: PlantSpeciesData

# Number of factors influencing growth chance
const num_growth_factors = 3

# Identifies plant instance
var plant_id: int
# Environmental conditions, as they pertain to this species
var growth_conditions: Vector4
# Average of all environmental conditions
var spot_growth_chance: float
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
func update_plant(cons_dict: Dictionary, spot_con: Vector3) -> void:
	var spot_growth_chance = compute_growth_chance(spot_con)
	var mean_total = 0.0
	var sig_total = 0.0
	for n in cons_dict:
		var p = MathUtil.average([cons_dict[n], spot_growth_chance]) * species_data.base_growth_chance
		mean_total += n * p
		sig_total += n * p * (1 - p)
	var num_successes = MathUtil.binomial_dist(mean_total, sig_total)
	grow(num_successes)

func get_species() -> String:
	return species_data.plant_species_name

# Grow the appropriate number of stages
func grow(stages: int) -> int:
	var low_end = clamp(growth_stage, species_data.mature_range.x, species_data.mature_range.y)
	growth_stage = max(growth_stage + stages, species_data.total_stages)
	var high_end = clamp(growth_stage, species_data.mature_range.x, species_data.mature_range.y)
	if growth_stage >= species_data.mature_stage:
		mature = true
	if growth_stage >= species_data.total_stages:
		die.emit(position)
	return high_end - low_end

# 0: Water
# 1: Light
# 2: Temp
# 3: Polination

func process_region_conditions(cond_dict: Dictionary) -> Dictionary:
	var species_cache_dict: Dictionary
	for t in cond_dict:
		var compute = compute_growth_chance(cond_dict[t])
		species_cache_dict[t] = compute_vec
	return species_cache_dict

# Computes the overall conditions
func compute_growth_chance(environment: Vector3) -> float:
	var chance = 0.0
	var w_con = compute_single_condition(0, environment.x)	
	var l_con = compute_single_condition(1, environment.y)
	var t_con = compute_single_condition(2, environment.z)
	chance = MathUtil.average([w_con, l_con, t_con])
	return chance
	
# Computes the quality of a single condition
func compute_single_condition(cond_num: int, val: float) -> float:
	var mean = species_data.growth_factors[cond_num][0]
	var sig = species_data.growth_factors[cond_num][1]
	var new_cond_val = MathUtil.normal_dist(val, mean, sig)
	growth_conditions[cond_num] = new_cond_val
	return new_cond_val
