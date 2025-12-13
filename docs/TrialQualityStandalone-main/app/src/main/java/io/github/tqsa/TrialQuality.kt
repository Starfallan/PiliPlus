package io.github.tqsa

import de.robv.android.xposed.IXposedHookLoadPackage
import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XposedBridge
import de.robv.android.xposed.XposedHelpers
import de.robv.android.xposed.callbacks.XC_LoadPackage

import io.github.tqsa.Utils.HookMethod

class Hook : IXposedHookLoadPackage {

    val targetPackage = listOf("tv.danmaku.bili", "com.bilibili.app.in", "tv.danmaku.bilibilihd", "com.bilibili.app.blue")

    override fun handleLoadPackage(loadPackageParam: XC_LoadPackage.LoadPackageParam) {
        if (loadPackageParam.packageName in targetPackage) {
            XposedBridge.hookAllMethods(
                XposedHelpers.findClass("android.app.ActivityThread", loadPackageParam.classLoader),
                "performLaunchActivity",
                object : XC_MethodHook() {
                    override fun afterHookedMethod(param: MethodHookParam) {
                        HookMethod.setBoolean("com.bapis.bilibili.pgc.gateway.player.v2.SceneControl", "setIsNeedTrial" , true , loadPackageParam.classLoader)
                        HookMethod.setBoolean("com.bapis.bilibili.playershared.VideoVod", "setIsNeedTrial" , true , loadPackageParam.classLoader)
                        HookMethod.getBoolean("com.bapis.bilibili.pgc.gateway.player.v2.SceneControl", "getIsNeedTrial", true , loadPackageParam.classLoader)
                        HookMethod.getBoolean("com.bapis.bilibili.playershared.VideoVod", "getIsNeedTrial", true , loadPackageParam.classLoader)
                        HookMethod.redirectGetField("com.bapis.bilibili.app.playurl.v1.StreamInfo", "getVipFree" , "needVip_" , loadPackageParam.classLoader)
                        HookMethod.redirectGetField("com.bapis.bilibili.playershared.StreamInfo", "getVipFree" , "needVip_" , loadPackageParam.classLoader)
                        HookMethod.getBoolean("com.bapis.bilibili.app.playurl.v1.StreamInfo", "getNeedVip", false , loadPackageParam.classLoader)
                        HookMethod.getBoolean("com.bapis.bilibili.playershared.StreamInfo", "getNeedVip", false , loadPackageParam.classLoader)
                    }
                }
            )
            HookMethod.Logger("[Success] Hooked ${loadPackageParam.packageName} !")
        } else {
            HookMethod.Logger("[Error] Why you want to hook ${loadPackageParam.packageName} ?")
        }
    }
}