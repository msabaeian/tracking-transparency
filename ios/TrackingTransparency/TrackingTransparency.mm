#import <Foundation/Foundation.h>
#import "TrackingTransparency.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

String const PERMISSION_AUTHORIZATION_RECEIVED = "permission_authorization_received";

void TrackingTransparency::_bind_methods() {
    ClassDB::bind_method(D_METHOD("getTrackingAuthorizationStatus"), &TrackingTransparency::getTrackingAuthorizationStatus);
    ClassDB::bind_method(D_METHOD("requestPermission"), &TrackingTransparency::requestPermission);
    ClassDB::bind_method(D_METHOD("getAdvertisingId"), &TrackingTransparency::getAdvertisingId);
    ClassDB::bind_method(D_METHOD("openAppSettings"), &TrackingTransparency::openAppSettings);
    ADD_SIGNAL(MethodInfo(PERMISSION_AUTHORIZATION_RECEIVED, PropertyInfo(Variant::INT, "result")));
}

String TrackingTransparency::getAdvertisingId() {
    return [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] UTF8String];
}

void TrackingTransparency::requestPermission() {
    if (@available(iOS 14, *)) {
        if (![[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSUserTrackingUsageDescription"]) {
            ERR_PRINT("TrackingTransparency: NSUserTrackingUsageDescription not found");
            emit_signal(PERMISSION_AUTHORIZATION_RECEIVED, (int)ATTrackingManagerAuthorizationStatusDenied);
            return;
        }

        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                emit_signal(PERMISSION_AUTHORIZATION_RECEIVED, (int)status);
            });
        }];
        return;
    }

    emit_signal(PERMISSION_AUTHORIZATION_RECEIVED, (int)ATTrackingManagerAuthorizationStatusAuthorized);
}

void TrackingTransparency::openAppSettings() {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
        [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                ERR_PRINT("TrackingTransparency: Failed to open app settings.");
            }
        }];
        return;
    }
    
    ERR_PRINT("TrackingTransparency: Cannot open app settings.");
}

int TrackingTransparency::getTrackingAuthorizationStatus() {
    if (@available(iOS 14, *)) {
        return (int)[ATTrackingManager trackingAuthorizationStatus];
    }
    return (int)ATTrackingManagerAuthorizationStatusAuthorized;
}


TrackingTransparency::TrackingTransparency() {
    print_verbose("TrackingTransparency: init");
}

TrackingTransparency::~TrackingTransparency() {
    print_verbose("TrackingTransparency: deinit");
}
