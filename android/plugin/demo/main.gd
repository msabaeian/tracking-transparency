extends Node2D

# TODO: Update to match your plugin's name
var _plugin_name = "TrackingTransparency"
var _android_plugin
@onready var btn = $Button

func _ready():
	btn.text = "hello"
	if Engine.has_singleton(_plugin_name):
		_android_plugin = Engine.get_singleton(_plugin_name)
	else:
		printerr("Couldn't find plugin " + _plugin_name)

func _on_Button_pressed():
	btn.text = "pressed"
	if _android_plugin:
		btn.text = "plugin"
		# TODO: Update to match your plugin's API
		var value = _android_plugin.getAdvertisingId()
		if value:
			btn.text = value
		
