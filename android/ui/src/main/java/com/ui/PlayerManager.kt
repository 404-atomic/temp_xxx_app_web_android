package com.ui

import android.app.Activity
import android.graphics.PixelFormat
import android.view.View
import android.view.WindowManager


class PlayerManager() {
    companion object {
        private val instance = PlayerManager()
        fun get() = instance

        fun init(context: Activity) {
            instance.activity = context
        }
    }

    private lateinit var activity: Activity

    var videoView: View? = null


    fun attachToWindow(videoView: View?) {
        try {
            videoView ?: return
            this.videoView = videoView
            activity.windowManager?.addView(
                videoView,
                WindowManager.LayoutParams(
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.TYPE_APPLICATION_PANEL,
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                    PixelFormat.TRANSLUCENT
                )
            )
            activity.requestedOrientation =
                android.content.pm.ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
            fullScreen(videoView)
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }

    fun detachFromWindow() {
        try {
            videoView ?: return
            activity.windowManager?.removeViewImmediate(videoView)
            videoView = null
            activity?.runOnUiThread {
                //强制设置竖屏
                activity.requestedOrientation =
                    android.content.pm.ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }

    private fun fullScreen(view: View) {
        view.systemUiVisibility = (View.SYSTEM_UI_FLAG_LOW_PROFILE
                or View.SYSTEM_UI_FLAG_FULLSCREEN
                or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION)
    }

    fun canGoBack(): Boolean {
        return videoView != null
    }
}