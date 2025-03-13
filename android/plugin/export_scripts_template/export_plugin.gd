@tool
extends EditorPlugin

# A class member to hold the editor export plugin during its lifecycle.
var export_plugin : AndroidExportPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_export_plugin(export_plugin)
	export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = "TrackingTransparency"

	func _supports_platform(platform):
		return platform is EditorExportPlatformAndroid

	func _get_android_libraries(_platform, debug):
		if debug:
			return PackedStringArray([_plugin_name + "/bin/debug/" + _plugin_name + "-debug.aar"])
		return PackedStringArray([_plugin_name + "/bin/release/" + _plugin_name + "-release.aar"])

	func _get_android_dependencies(_platform, _debug):
		return PackedStringArray(["com.google.android.gms:play-services-ads-identifier:18.0.1"])

	func _get_android_manifest_element_contents(_platform, _debug):
		return '<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>'

	func _get_name():
		return _plugin_name
