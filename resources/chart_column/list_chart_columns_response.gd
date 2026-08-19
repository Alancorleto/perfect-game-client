class_name ListChartColumnsResponse
extends Serializable

var chart_columns: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	chart_columns.clear()
	for cc_dict: Dictionary in from_dict["chart_columns"]:
		chart_columns.append(ChartColumnResponse.new(cc_dict))
