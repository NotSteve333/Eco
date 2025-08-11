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
var growth_factor: float
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
func update_plant(np: float) -> bool:
	var npc = np * growth_factor
	if can_grow and tick_val > (1 - species_data.base_growth_chance):
		grow()
	if mature:
		var tick_polination = growth_conditions[num_growth_factors]
		if tick_polination - (1 - species_data.base_spread_chance) * MathUtil.bool_to_unit(can_spread):
			can_spread = !can_spread
			spread.emit(can_spread)
	return false
	
func simulate_plant_ticks(npc: float) -> int:
	

func grow() -> void:
	growth_stage += 1
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
	growth_factor = 0.0
	growth_factor = MathUtil.average(growth_conditions.slice(0, num_growth_factors))
	return growth_factor
	
# Computes the quality of a single condition
func compute_single_condition(cond_num: int, val: float) -> float:
	var mean = species_data.growth_factors[cond_num][0]
	var sig = species_data.growth_factors[cond_num][1]
	var new_cond_val = MathUtil.normal_dist(val, mean, sig)
	growth_conditions[cond_num] = new_cond_val
	return new_cond_val
