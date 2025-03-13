@tool
extends EditorPlugin

var android_export_plugin: TrackingTransparencyAndroidExportPlugin 

func _enter_tree() -> void:
	android_export_plugin = TrackingTransparencyAndroidExportPlugin.new()
	add_autoload_singleton("TrackingTransparency", "tracking_node.gd")
	add_export_plugin(android_export_plugin)

func _exit_tree() -> void:
	remove_export_plugin(android_export_plugin)
	android_export_plugin = null

class TrackingTransparencyAndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = "TrackingTransparency"

	func _supports_platform(platform):
		return platform is EditorExportPlatformAndroid

	func _get_android_libraries(_platform, debug):
		if debug:
			return PackedStringArray(["tracking_transparency/bin/debug/" + _plugin_name + "-debug.aar"])
		return PackedStringArray(["tracking_transparency/bin/release/" + _plugin_name + "-release.aar"])

	func _get_android_dependencies(_platform, _debug):
		return PackedStringArray(["com.google.android.gms:play-services-ads-identifier:18.0.1"])

	func _get_android_manifest_element_contents(_platform, _debug):
		return '<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>'

	func _get_name():
		return _plugin_name
