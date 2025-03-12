#pragma once

#include "core/object/object.h"
#include "core/object/class_db.h"

extern String const PERMISSION_AUTHORIZATION_RECEIVED;


class TrackingTransparency : public Object {
    GDCLASS(TrackingTransparency, Object);
    static void _bind_methods();
    
public:
    int getTrackingAuthorizationStatus();
    String getAdvertisingId();
    void requestPermission();
    void openAppSettings();
    
    TrackingTransparency();
    ~TrackingTransparency();
};
