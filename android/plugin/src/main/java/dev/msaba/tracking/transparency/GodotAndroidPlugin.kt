package msaba.dev.tracking.transparency

import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.UsedByGodot
import com.google.android.gms.ads.identifier.AdvertisingIdClient

class GodotAndroidPlugin(godot: Godot): GodotPlugin(godot) {

    override fun getPluginName() = BuildConfig.GODOT_PLUGIN_NAME

    @UsedByGodot
    fun getAdvertisingId(): String? {
        return activity?.let { AdvertisingIdClient.getAdvertisingIdInfo(it.applicationContext).id }
    }

    @UsedByGodot
    fun isLimitAdTrackingEnabled(): Boolean? {
        return activity?.let { AdvertisingIdClient.getAdvertisingIdInfo(it.applicationContext).isLimitAdTrackingEnabled }
    }
}
