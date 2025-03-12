#import <Foundation/Foundation.h>
#import "TrackingTransparency.h"
#import "TrackingTransparencyPlugin.h"
#import "core/config/engine.h"

TrackingTransparency *plugin;

void TrackingTransparencyInitialize() {
    plugin = memnew(TrackingTransparency);
    Engine::get_singleton()->add_singleton(Engine::Singleton("TrackingTransparency", plugin));
}

void TrackingTransparencyTerminate() {
   if (plugin) {
       memdelete(plugin);
   }
}
