package com.foom.app.v2

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.app.AppOpsManager
import android.content.Intent
import android.provider.Settings
import android.app.usage.UsageStatsManager
import android.app.usage.UsageStats
import android.content.pm.PackageManager
import java.util.*
import kotlin.collections.HashMap

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.foom.app.v2/usage"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasUsageAccess" -> {
                    result.success(hasUsageStatsPermission())
                }
                "requestUsageAccess" -> {
                    val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                    startActivity(intent)
                    result.success(true)
                }
                "getDailyUsage" -> {
                    val minutes = getDailyUsageMinutes()
                    result.success(minutes)
                }
                "getWeeklyUsage" -> {
                    val weeklyData = getWeeklyUsageData()
                    result.success(weeklyData)
                }
                "getAppUsage" -> {
                    val appUsageList = getAppUsageList()
                    result.success(appUsageList)
                }
                "getYesterdayUsage" -> {
                    val minutes = getYesterdayUsageMinutes()
                    result.success(minutes)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        // Blocking service channel
        val blockingChannel = "com.foom.app.v2/blocking"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, blockingChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasAccessibility" -> {
                    result.success(false)
                }
                "requestAccessibility" -> {
                    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                    startActivity(intent)
                    result.success(true)
                }
                "blockApp", "unblockApp" -> {
                    result.success(null)
                }
                "isAppBlocked" -> {
                    result.success(false)
                }
                "getBlockedApps" -> {
                    result.success(listOf<String>())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }
    
    private fun getDailyUsageMinutes(): Int {
        if (!hasUsageStatsPermission()) return 0
        
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        val startTime = calendar.timeInMillis
        val endTime = System.currentTimeMillis()
        
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )
        
        var totalTime = 0L
        for (stat in stats) {
            totalTime += stat.totalTimeInForeground
        }
        
        return (totalTime / 1000 / 60).toInt()
    }
    
    private fun getYesterdayUsageMinutes(): Int {
        if (!hasUsageStatsPermission()) return 0
        
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val calendar = Calendar.getInstance()
        calendar.add(Calendar.DAY_OF_YEAR, -1)
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        val startTime = calendar.timeInMillis
        calendar.set(Calendar.HOUR_OF_DAY, 23)
        calendar.set(Calendar.MINUTE, 59)
        calendar.set(Calendar.SECOND, 59)
        val endTime = calendar.timeInMillis
        
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )
        
        var totalTime = 0L
        for (stat in stats) {
            totalTime += stat.totalTimeInForeground
        }
        
        return (totalTime / 1000 / 60).toInt()
    }
    
    private fun getWeeklyUsageData(): Map<String, Int> {
        if (!hasUsageStatsPermission()) {
            return mapOf(
                "mon" to 0, "tue" to 0, "wed" to 0, "thu" to 0,
                "fri" to 0, "sat" to 0, "sun" to 0
            )
        }
        
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val result = HashMap<String, Int>()
        val days = listOf("mon", "tue", "wed", "thu", "fri", "sat", "sun")
        
        for (i in 0..6) {
            val calendar = Calendar.getInstance()
            calendar.add(Calendar.DAY_OF_YEAR, -i)
            calendar.set(Calendar.HOUR_OF_DAY, 0)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)
            val startTime = calendar.timeInMillis
            calendar.set(Calendar.HOUR_OF_DAY, 23)
            calendar.set(Calendar.MINUTE, 59)
            calendar.set(Calendar.SECOND, 59)
            val endTime = calendar.timeInMillis
            
            val stats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                startTime,
                endTime
            )
            
            var totalTime = 0L
            for (stat in stats) {
                totalTime += stat.totalTimeInForeground
            }
            
            val dayIndex = (6 - i + calendar.get(Calendar.DAY_OF_WEEK)) % 7
            result[days[dayIndex]] = (totalTime / 1000 / 60).toInt()
        }
        
        return result
    }
    
    private fun getAppUsageList(): List<Map<String, Any>> {
        if (!hasUsageStatsPermission()) return emptyList()
        
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val packageManager = packageManager
        
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        val startTime = calendar.timeInMillis
        val endTime = System.currentTimeMillis()
        
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )
        
        val appUsageList = mutableListOf<Map<String, Any>>()
        
        for (stat in stats) {
            if (stat.totalTimeInForeground > 0) {
                try {
                    val appInfo = packageManager.getApplicationInfo(stat.packageName, 0)
                    val appName = packageManager.getApplicationLabel(appInfo).toString()
                    val minutes = (stat.totalTimeInForeground / 1000 / 60).toInt()
                    
                    if (minutes > 0) {
                        appUsageList.add(
                            mapOf(
                                "packageName" to stat.packageName,
                                "appName" to appName,
                                "usageMinutes" to minutes
                            )
                        )
                    }
                } catch (e: PackageManager.NameNotFoundException) {
                    // App not found, skip
                }
            }
        }
        
        return appUsageList.sortedByDescending { 
            (it["usageMinutes"] as? Int) ?: 0 
        }
    }
}

