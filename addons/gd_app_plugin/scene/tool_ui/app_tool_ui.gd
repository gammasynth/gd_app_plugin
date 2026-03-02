#|*******************************************************************
# app_tool_ui.gd
#*******************************************************************
# This file is part of gd_app_plugin.
# 
# gd_app_plugin is an open-source software plugin for the Godot Engine.
# gd_app_plugin is licensed under the MIT license.
# 
# https://github.com/gammasynth/gd_app_plugin
#*******************************************************************
# Copyright (c) 2026 AD - present; 1447 AH - present, Gammasynth.  
# Gammasynth (Gammasynth Software), Texas, U.S.A.
# 
# This software is licensed under the MIT license.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
#|*******************************************************************

@tool
extends Control
class_name AppToolUI

var resource:AppToolUIResouce
var inspector:EditorInspector
@onready var scroll_container: ScrollContainer = $ScrollContainer


func _ready() -> void:
	if not Engine.is_editor_hint(): return
	
	resource = AppToolUIResouce.new()
	resource.dock_control = self
	
	# CRITICAL: Enable vertical scrolling, disable horizontal to mimic the real Inspector
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	
	inspector = EditorInspector.new()
	
	# CRITICAL: Set size flags so it fills the ScrollContainer
	inspector.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	scroll_container.add_child(inspector)
	
	inspector.edit(resource)
