extends Node
# I LOVE TUPLES
class_name Tuple

# Data stored for tuples
var head_elem: Variant
var tail_elem: Variant
# Active references value for safe memory management
var references: int

func head() -> Variant:
	return head_elem
	
func tail() -> Variant:
	return tail_elem

# Ordering for arrays
func tuple_sort(a: Tuple, b: Tuple) -> bool:
	return a.head() < b.head()

func borrow() -> void:
	references += 1

func done() -> void:
	references -= 1
	if references <= 0:
		queue_free()

func _init(head: Variant, tail: Variant):
	head_elem = head
	tail_elem = tail
	references = 1
	
