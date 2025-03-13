@tool
extends Node

signal authorization_status_received(status: AuthorizationStatus)

enum AuthorizationStatus {
    NOT_DETERMINED = 0,
    RESTRICTED,
    DENIED,
    AUTHORIZED,
}

var _plugin

func _ready():
    if Engine.has_singleton("TrackingTransparency"):
        _plugin = Engine.get_singleton("TrackingTransparency")
        
        if _plugin.has_signal("permission_authorization_received"):
            _plugin.connect("permission_authorization_received", _on_authorization_status_received)

## requests permission from the user to track them
## the result is emitted through the authorization_status_received signal
## on iOS below 14, always emits AUTHORIZED
## on Android, this emits AUTHORIZED if the user has not opted out of tracking, otherwise DENIED
func request_permission():
    if not _plugin:
        return
    
    match OS.get_name():
        "iOS":
            _plugin.requestPermission()
        "Android":
            _on_authorization_status_received(_get_android_authorization_status())

## returns the advertising ID
## on iOS, this is the [url=https://developer.apple.com/documentation/adsupport/asidentifiermanager/advertisingidentifier]IDFA[/url]
## on Android, this is the [url=https://support.google.com/googleplay/android-developer/answer/6048248?hl=en]Android Advertising ID[/url]
## on iOS 14 and above, this returns null if the permission is not granted
## on Android, this returns null if the permission is not granted
func get_advertising_id():
    if not _plugin:
        return null
    
    var id = _plugin.getAdvertisingId()
    return id if id && id != "00000000-0000-0000-0000-000000000000" else null

## opens the app settings to allow the user to change the permission
## only available on iOS
func open_app_settings():
    if not _plugin or OS.get_name() != "iOS":
        return
    _plugin.openAppSettings()

## returns the tracking authorization status
## on iOS below 14, this always returns AUTHORIZED
## on Android, this returns AUTHORIZED if the user has not opted out of tracking, otherwise DENIED
func get_tracking_authorization_status():
    if not _plugin:
        return null
    
    match OS.get_name():
        "iOS":
            return _plugin.getTrackingAuthorizationStatus()
        "Android":
            return _get_android_authorization_status()
        _:
            return null

func _on_authorization_status_received(status):
    authorization_status_received.emit(status)

func _get_android_authorization_status():
    return AuthorizationStatus.AUTHORIZED if not _plugin.isLimitAdTrackingEnabled() else AuthorizationStatus.DENIED
