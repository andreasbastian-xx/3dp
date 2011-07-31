G21 (This is GCode, generated with Skeinforge version 35 from ReplicatorG)
G21 (Ultimaker profile - Quality print - alterations/start-centered.gcode)
G21 (Metric: The unit is a millimeter)
M18 (Disable motors for now, to allow manual moving of the head)
G90 (Absolute Positioning)
G92 X0 Y0 Z0 E0 (set origin to current position)
M1 (Check if the platform is empty before continuing)
G1 X-220.0 Y-220.0 F2000 (ensure you're in the front left corner)
G92 X-110 Y-110 Z220 E0 (make the center the origin)
G1 X0.0 Y0.0 F3000 (go back to the center)
G1 Z210.0 F100 (let the platform go up slightly, start slowly)
G1 Z0.0 F400 (we don't have all day...)
G92 X0 Y0 Z0 E0 (make the center the origin)
G91 (Relative positioning)
G1 Z35.0 F400 (lower platform for cleaning nozzle)
G92 E0 (zero the extruded length)
G1 E260 F1000 (extrude some to get the flow going)
G1 E-20 F3000 (reverse a little)
G92 E0 (zero the extruded length)
M1 (Clean the nozzle and press YES to continue...)
G1 Z-1.0 F100 (rise platform again)
G1 Z-34.0 F400 (rise platform again)
G90 
G1 Z0.4
G92 E0 (zero the extruded length)
G21 (end of start .gcode file)
G90
G21
;M103
M105
M106
M113 S1.0
;M108 S50.04
M104 S245.0
M104 S244.19
;M108 S22.33
;M108 S23.45
G1 X11.06 Y-2.79 Z0.3 F963.888
;M101
G1 X11.06 Y42.79 Z0.3 F963.888 E66.535
G1 X17.64 Y42.79 Z0.3 F963.888 E76.142
G1 X17.64 Y-2.79 Z0.3 F963.888 E142.677
G1 X11.06 Y-2.79 Z0.3 F963.888 E152.283
;M103
G1 X14.16 Y0.21 Z0.3 F2141.973
;M101
G1 X14.64 Y0.21 Z0.3 F963.888 E152.987
G1 X14.64 Y39.79 Z0.3 F963.888 E210.764
G1 X14.06 Y39.79 Z0.3 F963.888 E211.612
G1 X14.06 Y0.21 Z0.3 F963.888 E269.389
G1 X14.16 Y0.21 Z0.3 F963.888 E269.533
;M103
M104 S245.0
;M108 S39.41
M104 S0
;M103
M104 S0 (end.gcode v2.0 - turning off extruder )
G90 (absolute positioning - end of end.gcode)
G92 X0 Y0 Z0 (set current as home position)
G92 E0 (reset extrusion position)
G1 X-20.0 F3000.0 (rapidly move extruder away from the object, hopefully)
G1 Z10.0 F400.0 (platform down a little more)
G90 (absolute positioning - end of end.gcode)
M113 S0.0
M107
