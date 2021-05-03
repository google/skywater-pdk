
Technology	{
		name				= "sky130_fd_sc_hd.tf"
		date				= "Apr 28 2020"
		dielectric			= 3.45e-05
		unitTimeName			= "ns"
		timePrecision			= 1000
		unitLengthName			= "micron"
		lengthPrecision			= 1000
		gridResolution			= 5
		unitVoltageName			= "V"
		voltagePrecision		= 1000000
		unitCurrentName			= "mA"
		currentPrecision		= 1000000
		unitPowerName			= "mw"
		powerPrecision			= 1000000
		unitResistanceName		= "kohm"
		resistancePrecision		= 1000000
		unitCapacitanceName		= "pf"
		capacitancePrecision		= 1000000
		unitInductanceName		= "nh"
		inductancePrecision		= 100
		minBaselineTemperature		= 25
		nomBaselineTemperature		= 25
		maxBaselineTemperature		= 25
		fatWireViaKeepoutMode		= 1
}

Color		43 {
		name				= "43"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 175
		blueIntensity			= 255
}

Color		47 {
		name				= "47"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 255
		blueIntensity			= 255
}

Tile		"unit" {
		width				= 0.46
		height				= 2.72
}

Tile		"unithddbl" {
		width				= 0.46
		height				= 5.44
}

Layer		"licon1" {
		layerNumber			= 1
		maskName			= "subcont"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "43"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.17
		minWidth			= 0.17
		minSpacing			= 0.19
}

Layer		"li1" {
		layerNumber			= 2
		maskName			= "metal1"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "cyan"
		lineStyle			= "solid"
		pattern				= "slash"
		pitch				= 0.46
		defaultWidth			= 0.17
		minWidth			= 0.17
		minSpacing			= 0.17
		unitMinResistance		= 0.0122
		unitNomResistance		= 0.0122
		unitMaxResistance		= 0.0122
		unitMinThickness		= 0.1
		unitNomThickness		= 0.1
		unitMaxThickness		= 0.1
		fatTblDimension			= 2
		fatTblThreshold			= (0,3.001) 
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0) 
		fatTblSpacing			= (0.17, 0.34)  
		minArea				= 0.0561
}

Layer		"mcon" {
		layerNumber			= 3
		maskName			= "via1"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "43"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.17
		minWidth			= 0.17
		minSpacing			= 0.19
}

Layer		"met1" {
		layerNumber			= 4
		maskName			= "metal2"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "blue"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.34
		defaultWidth			= 0.14
		minWidth			= 0.14
		minSpacing			= 0.14
		unitMinResistance		= 0.000125
		unitNomResistance		= 0.000125
		unitMaxResistance		= 0.000125
		unitMinCapacitance		= 5.1e-05
		unitNomCapacitance		= 5.1e-05
		unitMaxCapacitance		= 5.1e-05
		unitMinThickness		= 0.35
		unitNomThickness		= 0.35
		unitMaxThickness		= 0.35
		fatTblDimension			= 2
		fatTblThreshold			= (0,3.001)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (0.14, 0.28)
		minArea				= 0.083
}

Layer		"via" {
		layerNumber			= 5
		maskName			= "via2"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "blue"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.15
		minWidth			= 0.15
		minSpacing			= 0.17
}

Layer		"met2" {
		layerNumber			= 6
		maskName			= "metal3"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.46
		defaultWidth			= 0.14
		minWidth			= 0.14
		minSpacing			= 0.14
		unitMinResistance		= 0.000125
		unitNomResistance		= 0.000125
		unitMaxResistance		= 0.000125
		unitMinCapacitance		= 1.8e-05
		unitNomCapacitance		= 1.8e-05
		unitMaxCapacitance		= 1.8e-05
		unitMinThickness		= 0.35
		unitNomThickness		= 0.35
		unitMaxThickness		= 0.35
		fatTblDimension			= 2
		fatTblThreshold			= (0,3.001)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (0.14, 0.28) 
		minArea				= 0.0676
}

Layer		"via2" {
		layerNumber			= 7
		maskName			= "via3"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.2
		minWidth			= 0.2
		minSpacing			= 0.2
}

Layer		"met3" {
		layerNumber			= 8
		maskName			= "metal4"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "purple"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.68
		defaultWidth			= 0.3
		minWidth			= 0.3
		minSpacing			= 0.3
		unitMinResistance		= 4.7e-05
		unitNomResistance		= 4.7e-05
		unitMaxResistance		= 4.7e-05
		unitMinCapacitance		= 2.5e-05
		unitNomCapacitance		= 2.5e-05
		unitMaxCapacitance		= 2.5e-05
		unitMinThickness		= 0.8
		unitNomThickness		= 0.8
		unitMaxThickness		= 0.8
		fatTblDimension			= 2
		fatTblThreshold			= (0,3.001)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (0.3, 0.4) 
		minArea				= 0.24
}

Layer		"via3" {
		layerNumber			= 9
		maskName			= "via4"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.2
		minWidth			= 0.2
		minSpacing			= 0.2
}

Layer		"met4" {
		layerNumber			= 10
		maskName			= "metal5"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.92
		defaultWidth			= 0.3
		minWidth			= 0.3
		minSpacing			= 0.3
		unitMinResistance		= 4.7e-05
		unitNomResistance		= 4.7e-05
		unitMaxResistance		= 4.7e-05
		unitMinCapacitance		= 1.7e-05
		unitNomCapacitance		= 1.7e-05
		unitMaxCapacitance		= 1.7e-05
		unitMinThickness		= 0.8
		unitNomThickness		= 0.8
		unitMaxThickness		= 0.8
		fatTblDimension			= 2
		fatTblThreshold			= (0,3.001)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (0.3, 0.4) 
		minArea				= 0.24
}

Layer		"via4" {
		layerNumber			= 11
		maskName			= "via5"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "47"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.8
		minWidth			= 0.8
		minSpacing			= 0.8
}

Layer		"met5" {
		layerNumber			= 12
		maskName			= "metal6"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "aqua"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 3.4
		defaultWidth			= 1.6
		minWidth			= 1.6
		minSpacing			= 1.6
		unitMinResistance		= 2.9e-05
		unitNomResistance		= 2.9e-05
		unitMaxResistance		= 2.9e-05
		unitMinCapacitance		= 1.3e-05
		unitNomCapacitance		= 1.3e-05
		unitMaxCapacitance		= 1.3e-05
		unitMinThickness		= 1.2
		unitNomThickness		= 1.2
		unitMaxThickness		= 1.2
		fatTblDimension			= 2
		fatTblThreshold			= (0,3.001)
		fatTblParallelLengthDimension	= 1
		fatTblParallelLength		= (0)
		fatTblSpacing			= (1.6, 3.2) 
		minArea				= 4
}

Layer		"fieldpoly" {
		layerNumber			= 13
		maskName			= "poly"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.46
		defaultWidth			= 0.14
		minWidth			= 0.14
		minSpacing			= 0.14
}


Layer		"diff" {
		layerNumber			= 14 
		maskName			= "diffusion"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "40"
		lineStyle			= "dash"
		pattern				= "dot"
		pitch				= 0
}


Layer		"nwell" {
		layerNumber			= 15 
		maskName			= "nwell"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "dash"
		pattern				= "dot"
		pitch				= 0
}

Layer		"pwell" {
		layerNumber			= 16 
		maskName			= "pwell"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "brown"
		lineStyle			= "dash"
		pattern				= "dot"
		pitch				= 0
}

ContactCode	"L1M1_PR" {
		contactCodeNumber		= 1
		cutLayer			= "mcon"
		lowerLayer			= "li1"
		upperLayer			= "met1"
		isDefaultContact		= 1
		cutWidth			= 0.17
		cutHeight			= 0.17
		upperLayerEncWidth		= 0.06
		upperLayerEncHeight		= 0.03
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.19
}

ContactCode	"L1M1_PR_R" {
		contactCodeNumber		= 2
		cutLayer			= "mcon"
		lowerLayer			= "li1"
		upperLayer			= "met1"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.17
		cutHeight			= 0.17
		upperLayerEncWidth		= 0.03
		upperLayerEncHeight		= 0.06
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.19
}

ContactCode	"L1M1_PR_M" {
		contactCodeNumber		= 3
		cutLayer			= "mcon"
		lowerLayer			= "li1"
		upperLayer			= "met1"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.17
		cutHeight			= 0.17
		upperLayerEncWidth		= 0.03
		upperLayerEncHeight		= 0.06
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.19
}

ContactCode	"L1M1_PR_MR" {
		contactCodeNumber		= 4
		cutLayer			= "mcon"
		lowerLayer			= "li1"
		upperLayer			= "met1"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.17
		cutHeight			= 0.17
		upperLayerEncWidth		= 0.06
		upperLayerEncHeight		= 0.03
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.19
}

ContactCode	"L1M1_PR_C" {
		contactCodeNumber		= 5
		cutLayer			= "mcon"
		lowerLayer			= "li1"
		upperLayer			= "met1"
		isDefaultContact		= 1
		cutWidth			= 0.17
		cutHeight			= 0.17
		upperLayerEncWidth		= 0.06
		upperLayerEncHeight		= 0.06
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.19
}

ContactCode	"M1M2_PR" {
		contactCodeNumber		= 6
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		isDefaultContact		= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.055
		upperLayerEncHeight		= 0.085
		lowerLayerEncWidth		= 0.085
		lowerLayerEncHeight		= 0.055
		minCutSpacing			= 0.17
}

ContactCode	"M1M2_PR_Enc" {
		contactCodeNumber		= 7
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.085
		upperLayerEncHeight		= 0.055
		lowerLayerEncWidth		= 0.085
		lowerLayerEncHeight		= 0.055
		minCutSpacing			= 0.17
}

ContactCode	"M1M2_PR_R" {
		contactCodeNumber		= 8
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.085
		upperLayerEncHeight		= 0.055
		lowerLayerEncWidth		= 0.055
		lowerLayerEncHeight		= 0.085
		minCutSpacing			= 0.17
}

ContactCode	"M1M2_PR_R_Enc" {
		contactCodeNumber		= 9
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.055
		upperLayerEncHeight		= 0.085
		lowerLayerEncWidth		= 0.055
		lowerLayerEncHeight		= 0.085
		minCutSpacing			= 0.17
}

ContactCode	"M1M2_PR_M" {
		contactCodeNumber		= 10
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.085
		upperLayerEncHeight		= 0.055
		lowerLayerEncWidth		= 0.085
		lowerLayerEncHeight		= 0.055
		minCutSpacing			= 0.17
}

ContactCode	"M1M2_PR_M_Enc" {
		contactCodeNumber		= 11
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.055
		upperLayerEncHeight		= 0.085
		lowerLayerEncWidth		= 0.085
		lowerLayerEncHeight		= 0.055
		minCutSpacing			= 0.17
}

ContactCode	"M1M2_PR_MR" {
		contactCodeNumber		= 12
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.055
		upperLayerEncHeight		= 0.085
		lowerLayerEncWidth		= 0.055
		lowerLayerEncHeight		= 0.085
		minCutSpacing			= 0.17
}

ContactCode	"M1M2_PR_MR_Enc" {
		contactCodeNumber		= 13
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.085
		upperLayerEncHeight		= 0.055
		lowerLayerEncWidth		= 0.055
		lowerLayerEncHeight		= 0.085
		minCutSpacing			= 0.17
}

ContactCode	"M1M2_PR_C" {
		contactCodeNumber		= 14
		cutLayer			= "via"
		lowerLayer			= "met1"
		upperLayer			= "met2"
		isDefaultContact		= 1
		cutWidth			= 0.15
		cutHeight			= 0.15
		upperLayerEncWidth		= 0.085
		upperLayerEncHeight		= 0.085
		lowerLayerEncWidth		= 0.085
		lowerLayerEncHeight		= 0.085
		minCutSpacing			= 0.17
}

ContactCode	"M2M3_PR" {
		contactCodeNumber		= 15
		cutLayer			= "via2"
		lowerLayer			= "met2"
		upperLayer			= "met3"
		isDefaultContact		= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0.085
		minCutSpacing			= 0.2
}

ContactCode	"M2M3_PR_R" {
		contactCodeNumber		= 16
		cutLayer			= "via2"
		lowerLayer			= "met2"
		upperLayer			= "met3"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.085
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.2
}

ContactCode	"M2M3_PR_M" {
		contactCodeNumber		= 17
		cutLayer			= "via2"
		lowerLayer			= "met2"
		upperLayer			= "met3"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0.085
		minCutSpacing			= 0.2
}

ContactCode	"M2M3_PR_MR" {
		contactCodeNumber		= 18
		cutLayer			= "via2"
		lowerLayer			= "met2"
		upperLayer			= "met3"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.085
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.2
}

ContactCode	"M2M3_PR_C" {
		contactCodeNumber		= 19
		cutLayer			= "via2"
		lowerLayer			= "met2"
		upperLayer			= "met3"
		isDefaultContact		= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.085
		lowerLayerEncHeight		= 0.085
		minCutSpacing			= 0.2
}

ContactCode	"M3M4_PR" {
		contactCodeNumber		= 20
		cutLayer			= "via3"
		lowerLayer			= "met3"
		upperLayer			= "met4"
		isDefaultContact		= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.09
		lowerLayerEncHeight		= 0.06
		minCutSpacing			= 0.2
}

ContactCode	"M3M4_PR_R" {
		contactCodeNumber		= 21
		cutLayer			= "via3"
		lowerLayer			= "met3"
		upperLayer			= "met4"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.06
		lowerLayerEncHeight		= 0.09
		minCutSpacing			= 0.2
}

ContactCode	"M3M4_PR_M" {
		contactCodeNumber		= 22
		cutLayer			= "via3"
		lowerLayer			= "met3"
		upperLayer			= "met4"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.09
		lowerLayerEncHeight		= 0.06
		minCutSpacing			= 0.2
}

ContactCode	"M3M4_PR_MR" {
		contactCodeNumber		= 23
		cutLayer			= "via3"
		lowerLayer			= "met3"
		upperLayer			= "met4"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.06
		lowerLayerEncHeight		= 0.09
		minCutSpacing			= 0.2
}

ContactCode	"M3M4_PR_C" {
		contactCodeNumber		= 24
		cutLayer			= "via3"
		lowerLayer			= "met3"
		upperLayer			= "met4"
		isDefaultContact		= 1
		cutWidth			= 0.2
		cutHeight			= 0.2
		upperLayerEncWidth		= 0.065
		upperLayerEncHeight		= 0.065
		lowerLayerEncWidth		= 0.09
		lowerLayerEncHeight		= 0.09
		minCutSpacing			= 0.2
}

ContactCode	"M4M5_PR" {
		contactCodeNumber		= 25
		cutLayer			= "via4"
		lowerLayer			= "met4"
		upperLayer			= "met5"
		isDefaultContact		= 1
		cutWidth			= 0.8
		cutHeight			= 0.8
		upperLayerEncWidth		= 0.31
		upperLayerEncHeight		= 0.31
		lowerLayerEncWidth		= 0.19
		lowerLayerEncHeight		= 0.19
		minCutSpacing			= 0.8
}

ContactCode	"M4M5_PR_R" {
		contactCodeNumber		= 26
		cutLayer			= "via4"
		lowerLayer			= "met4"
		upperLayer			= "met5"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.8
		cutHeight			= 0.8
		upperLayerEncWidth		= 0.31
		upperLayerEncHeight		= 0.31
		lowerLayerEncWidth		= 0.19
		lowerLayerEncHeight		= 0.19
		minCutSpacing			= 0.8
}

ContactCode	"M4M5_PR_M" {
		contactCodeNumber		= 27
		cutLayer			= "via4"
		lowerLayer			= "met4"
		upperLayer			= "met5"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.8
		cutHeight			= 0.8
		upperLayerEncWidth		= 0.31
		upperLayerEncHeight		= 0.31
		lowerLayerEncWidth		= 0.19
		lowerLayerEncHeight		= 0.19
		minCutSpacing			= 0.8
}

ContactCode	"M4M5_PR_MR" {
		contactCodeNumber		= 28
		cutLayer			= "via4"
		lowerLayer			= "met4"
		upperLayer			= "met5"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.8
		cutHeight			= 0.8
		upperLayerEncWidth		= 0.31
		upperLayerEncHeight		= 0.31
		lowerLayerEncWidth		= 0.19
		lowerLayerEncHeight		= 0.19
		minCutSpacing			= 0.8
}

ContactCode	"M4M5_PR_C" {
		contactCodeNumber		= 29
		cutLayer			= "via4"
		lowerLayer			= "met4"
		upperLayer			= "met5"
		contactSourceType		= 5
		isFatContact			= 1
		cutWidth			= 0.8
		cutHeight			= 0.8
		upperLayerEncWidth		= 0.31
		upperLayerEncHeight		= 0.31
		lowerLayerEncWidth		= 0.19
		lowerLayerEncHeight		= 0.19
		minCutSpacing			= 0.8
}

DesignRule	{
		layer1				= "via4"
		layer2				= "met4"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "via4"
		layer2				= "met5"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "via3"
		layer2				= "met3"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "via3"
		layer2				= "met4"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "via2"
		layer2				= "met2"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "via2"
		layer2				= "met3"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "via"
		layer2				= "met1"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "via"
		layer2				= "met2"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "mcon"
		layer2				= "li1"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}

DesignRule	{
		layer1				= "mcon"
		layer2				= "met1"
		minSpacing			= 0
		minEnclosure			= 0
		stackViaCenterSpacingThreshold	= 0
}


PRRule {
	rowSpacingTopTop = 0
	rowSpacingBotBot = 0.92
	abuttableTopTop = 1
	abuttableBotBot = 1
	rowSpacingTopBot = 0.17
	abuttableTopBot = 0
}

DensityRule	{
		layer				= "met1"
		windowSize			= 700
		maxDensity			= 70
}

DensityRule	{
		layer				= "met2"
		windowSize			= 700
		maxDensity			= 70
}

DensityRule	{
		layer				= "met3"
		windowSize			= 700
		maxDensity			= 70
}

DensityRule	{
		layer				= "met4"
		windowSize			= 700
		maxDensity			= 70
}
