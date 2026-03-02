#|*******************************************************************
# app_tool_ui_resource.gd
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
extends Resource
class_name AppToolUIResouce

var dock_control:Control = null

@export_category("Setup")
@export_group("Project Node Scene")
@export_file() var project_node_scene_path : String = ""
@export var project_node_loaded : bool = false
@export_tool_button("Load Project Node Scene") var load_project_node_scene_action: Callable = load_project_node_scene
var project_node_loading : bool = false
var project_node_scene: Node = null
@export_group("")

@export_category("Manage")
@export_group("Manage Project")
@export var app_resource:AppResource = null
@export_tool_button("Startup Project") var startup_project_action: Callable = startup_project
@export_tool_button("Update Project") var update_project_action: Callable = update_project
@export_group("")

func load_project_node_scene() -> void: 
	if project_node_loaded:
		print("AppToolUI | The project Node is already loaded! Cancelling.")
		return
	
	if project_node_loading:
		print("AppToolUI | The project Node is still loading!")
		print("AppToolUI | Please wait...")
		return
	
	if project_node_scene_path.is_empty():
		project_node_loaded = false
		print("AppToolUI | No project_node_scene_path to file!")
		print("AppToolUI | The project_node_scene_path is a String path to a saved Node scene. The scene should contain an instance of ToolNode Node as a child.")
		return
	
	project_node_loading = true
	project_node_scene = load(project_node_scene_path).instantiate()
	project_node_scene.ready.connect(project_node_was_loaded)
	
	dock_control.add_child(project_node_scene)

func project_node_was_loaded() -> void:
	if not validate_node_ref(): project_node_loaded = false
	else: project_node_loaded = true
	
	project_node_loading = false

func apply_node_refs() -> void:
	var app_tool = project_node_scene.get_child(0).get_child(5)#.get_node("AppTool")#replace child 5
	app_resource = app_tool.app_resource
	
	if not app_resource.node: app_resource.node = project_node_scene
	if not app_resource.json_tool_node: app_resource.json_tool_node = project_node_scene.get_child(0).get_child(4)#.get_node("JsonTool")#replace child 4

func validate_node_ref(node:Node=project_node_scene) -> bool: return node and is_instance_valid(node)

func startup_project() -> void:
	if not validate_node_ref(): return
	apply_node_refs()
	app_resource.startup_project()

func update_project() -> void: 
	if not validate_node_ref(): return
	apply_node_refs()
	app_resource.update_app()
