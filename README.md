# Tracking Transparency for Godot

A Godot plugin that provides a unified API for handling tracking transparency on both iOS and Android. This plugin allows you to request permission to track users and retrieve device advertising IDs in compliance with platform privacy requirements.

## Overview

This plugin handles two main tracking-related features:
1. Requesting permission to track the user (required on iOS 14+ and respects opt-out settings on Android)
2. Retrieving the device advertising ID (IDFA on iOS, AAID on Android)

## Compatibility

| Godot Version | Support
|---------------|------------
| 4.4           | ✅
| 4.3           | ✅
| 4.2           | not tested
| 3.x           | ❌


## Platform-Specific Behavior

### iOS
- On iOS 14 and higher, the plugin will display Apple's App Tracking Transparency prompt to request permission
- On iOS below 14, the plugin will always return `AUTHORIZED` status
- On iOS 14 and later, the IDFA (Identifier for Advertisers) will only be available if tracking permission is granted

### Android
- Returns `AUTHORIZED` if the user has not opted out of tracking, otherwise `DENIED`
- The AAID (Android Advertising ID) will be null if the user has opted out of tracking

## Installation and setup
1. Install directly from the Asset Library tab in Godot (recommended):
   - if you installed using this method, jump to step 4
2. Manual Installation:
   - Download the latest version from the Releases section
   - Copy the `addons/tracking_transparency` folder to your Godot project's `addons` directory
3. Enable the plugin in `Project Settings → Plugins`
4. Platforms configuration:
   - Android:
     - Enable [Use Gradle Build](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html) in your export settings
   - iOS:
     - Copy the files inside `addons/tracking_transparency/ios/[YOUR_GODOT_VERSION]` into the `ios/plugins` folder located at the root of your project (create this folder if it does not exist)
     - Check the "Tracking Transparency" option under `Project → Export → iOS → Plugins`
     - Add a tracking usage description in `Project → Export → iOS → Plugins Plist` by setting the `NSUserTrackingUsageDescription` key, you must provide a clear reason for tracking or Apple will reject your app/game during review

## Usage

**Note:** This plugin adds a singleton to your project runtime. If you want to have a node instead, you need to modify the plugin.gd file and use `add_custom_type` instead of `add_autoload_singleton`.

### Basic Implementation

```gdscript
extends Node

func _ready():
    # Connect to the authorization status signal
    TrackingTransparency.authorization_status_received.connect(_on_authorization_status_received)
    
    # Request tracking permission
    TrackingTransparency.request_permission()

# Handle the authorization result
func _on_authorization_status_received(status):
    match status:
        TrackingTransparency.AuthorizationStatus.AUTHORIZED:
            print("Advertising ID:", TrackingTransparency.get_advertising_id())
        TrackingTransparency.AuthorizationStatus.DENIED:
            print("Tracking denied by user")
        TrackingTransparency.AuthorizationStatus.RESTRICTED:
            print("Tracking restricted (usually by parental controls)")
        TrackingTransparency.AuthorizationStatus.NOT_DETERMINED:
            print("Tracking permission not determined yet")
```

## API Reference

### Enumerations

```gdscript
enum AuthorizationStatus {
    NOT_DETERMINED = 0,  # User has not been asked for permission yet
    RESTRICTED,          # Tracking is restricted (e.g., parental controls)
    DENIED,              # User has denied tracking permission
    AUTHORIZED,          # User has authorized tracking
}
```

### Methods

#### `request_permission()`
Requests permission from the user to track them and emits the result by emitting `authorization_status_received`
- On iOS 14+: displays the system tracking permission dialog
- On iOS 13 and earlier: always emit `AUTHORIZED`
- On iOS simulator, 
- On Android: no user prompt appears but the status will be check and emitted

#### `get_advertising_id()`
Returns the advertising ID as a string, or `null` if unavailable or not authorized
- On iOS: Returns the IDFA (Identifier for Advertisers)
- On Android: Returns the AAID (Android Advertising ID)
- On iOS simulator: Always returns `null`

#### `open_app_settings()`
_(iOS only)_
Opens the application settings page. Useful for directing users to change their tracking preferences if they've denied the permission before

#### `get_tracking_authorization_status()`
Returns the current authorization status without requesting permission
- On iOS below 14: Always returns `AUTHORIZED`
- On Android: Returns `AUTHORIZED` if the user has not opted out of tracking, otherwise `DENIED`

### Signals

#### `authorization_status_received(status: AuthorizationStatus)`
Emitted when an authorization status is received after calling `request_permission()`.


## License

This plugin is released under the MIT License. See the [LICENSE](LICENSE) file for details.
