package io.github.tqsa.Utils

import android.util.Log

import de.robv.android.xposed.XC_MethodHook
import de.robv.android.xposed.XC_MethodReplacement
import de.robv.android.xposed.XposedHelpers

object HookMethod {
    fun getBoolean(className: String, methodName: String, type: Boolean , classLoader: ClassLoader) {
        XposedHelpers.findAndHookMethod(
            className,
            classLoader,
            methodName,
            XC_MethodReplacement.returnConstant(type)
        )
        Logger("[Success] Hooked $className !")
    }

    fun setBoolean(className: String, methodName: String, type: Boolean , classLoader: ClassLoader) {
        try {
            XposedHelpers.findAndHookMethod(
                className,
                classLoader,
                methodName,
                Boolean::class.javaPrimitiveType,
                object : XC_MethodHook() {
                    override fun beforeHookedMethod(param: MethodHookParam) {
                        Logger("[Hooked] Forcing $methodName($type)")
                        param.args[0] = type
                    }
                }
            )
            Logger("[Success] Hook applied to $className.$methodName")
        } catch (e: NoSuchMethodError) {
            Logger("[Error] Method not found: ${e.message}")
        } catch (e: ClassNotFoundException) {
            Logger("[Error] Class not found: ${e.message}")
        } catch (e: Throwable) {
            Logger("[Fatal] Unexpected error: ${e.stackTraceToString()}")
        }
    }

    fun redirectGetField(className: String, methodName: String, fieldName: String , classLoader: ClassLoader) {
        XposedHelpers.findAndHookMethod(
            className,
            classLoader,
            methodName,
            object : XC_MethodHook() {
                override fun afterHookedMethod(param: MethodHookParam) {
                    val result = XposedHelpers.getBooleanField(param.thisObject, "$fieldName")
                    param.result = result
                }
            }
        )
    }

    fun Logger(msg: String) {
        Log.v("TrialQualityStandalone: ",msg)
    }
}