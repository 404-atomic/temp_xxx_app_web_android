package com.ui

import android.app.Activity
import android.content.Intent
import android.content.res.Configuration
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.view.Window
import android.webkit.WebSettings
import android.webkit.WebView

class WebviewActivity : Activity() {

    private var webView: WebView? = null

    private var playUlr: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        getWindow().requestFeature(Window.FEATURE_CONTENT_TRANSITIONS);
        PlayerManager.init(this)
        instance?.finish()
        instance = this
        setContentView(R.layout.activity_webview)
        webView = findViewById(R.id.webview)
        setupWebView()
        val url = intent.getStringExtra("url") ?: return
        //本地加载，禁止调用默认浏览器
        webView?.loadUrl(url)
    }

    private fun setupWebView() {
        webView?.settings?.javaScriptEnabled = true
        webView?.settings?.domStorageEnabled = true
        webView?.settings?.cacheMode = WebSettings.LOAD_DEFAULT
        webView?.settings?.allowFileAccess = true
        webView?.settings?.allowContentAccess = true
        webView?.settings?.allowFileAccessFromFileURLs = true
        webView?.settings?.allowUniversalAccessFromFileURLs = true
        webView?.settings?.setSupportZoom(false)
        webView?.settings?.builtInZoomControls = false
        webView?.settings?.displayZoomControls = false
        webView?.settings?.useWideViewPort = true
        webView?.settings?.loadWithOverviewMode = true
        webView?.settings?.javaScriptCanOpenWindowsAutomatically = true
        webView?.settings?.loadsImagesAutomatically = true
        webView?.settings?.blockNetworkImage = false
        webView?.settings?.blockNetworkLoads = false
        //设置useragent
        webView?.settings?.userAgentString = DomainHelper.userAgent
        //拦截部分url
        webView?.webViewClient = object : android.webkit.WebViewClient() {
            @Deprecated("Deprecated in Java")
            override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
                val result = handleUrl(url ?: "")
                if (isPlayUrl(url) != null) {
                    playUlr = url
                }
                if (result) {
                    view?.loadUrl(url ?: "")
                } else {
                    try {
                        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                        startActivity(intent)
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
                return true
            }
        }

        handlePlayFullScreen()
    }

    /**
     * 判断是否是播放地址,如果是播放地址，返回播放地址，否则返回null
     */
    private fun isPlayUrl(url: String?): String? {
        if (url == null) {
            return null
        }
        if (url.contains(".mp4") || url.contains(".m3u8") || url.contains(".flv")) {
            return url
        }
        return null
    }

    private fun handlePlayFullScreen() {
        webView?.webChromeClient = object : android.webkit.WebChromeClient() {
            override fun onShowCustomView(view: View?, callback: CustomViewCallback?) {
                PlayerManager.get().attachToWindow(view)
            }

            override fun onHideCustomView() {
                PlayerManager.get().detachFromWindow()
//                //刷新
                webView?.reload()
            }
        }
    }


    private fun handleUrl(url: String): Boolean {
        DomainHelper.config?.whiteList?.forEach {
            if (url.contains(it)) {
                return@handleUrl true
            }
        }
        val domain1 = getDomain(url)
        val domain2 = getDomain(DomainHelper.DefaultWebDomain)
        return domain1 == domain2
    }

    //m.v.qq.com 、x.qq.com、z.x.x.qq.com、 v.qq.com，提取为qq.com
    private fun getDomain(url: String): String {
        val domain = url.replace("http://", "")
            .replace("https://", "")
            .replace("www.", "")
            .split("/")[0]
        val split = domain.split(".")
        return if (split.size > 2) {
            split[split.size - 2] + "." + split[split.size - 1]
        } else {
            domain
        }
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        // Handle configuration changes if needed
    }

    // In WebviewActivity.kt
    override fun onDestroy() {
        super.onDestroy()
        PlayerManager.get().detachFromWindow()
    }


    override fun onBackPressed() {
        if (PlayerManager.get().canGoBack()) {
            PlayerManager.get().detachFromWindow()
            webView?.reload()
            return
        } else if (webView?.canGoBack() == true) {
            webView?.goBack()
        } else {
            super.onBackPressed()
        }
    }

    companion object {
        var instance: WebviewActivity? = null

        fun start(activity: Activity, url: String) {
            //不要动画
            val intent = Intent(activity, WebviewActivity::class.java)
            intent.putExtra("url", url)
            activity.startActivity(intent)
            activity.overridePendingTransition(R.anim.in_anim, R.anim.out_anim);
            activity.finish()
        }
    }
}