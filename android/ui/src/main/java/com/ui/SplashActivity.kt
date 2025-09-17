package com.ui

import android.app.Activity
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.widget.ImageView
import android.widget.TextView
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.net.HttpURLConnection
import java.net.URL

class SplashActivity : Activity() {
    private var ivSplash: ImageView? = null
    private var tvSkip: TextView? = null
    private var countDown = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)
        ivSplash = findViewById(R.id.iv_splash)
        tvSkip = findViewById(R.id.tv_skip)
        GlobalScope.launch(Dispatchers.IO) {
            val url = DomainHelper.refreshAvailableDomain(this@SplashActivity) ?: return@launch
            loadImageView(DomainHelper.config?.adImageUrl ?: "")
            withContext(Dispatchers.Main) {
                tvSkip?.visibility =
                    if ((DomainHelper.config?.adCountdown
                            ?: 0) > 0
                    ) android.view.View.VISIBLE else android.view.View.GONE
                ivSplash?.visibility = if ((DomainHelper.config?.adCountdown
                        ?: 0) > 0
                ) android.view.View.VISIBLE else android.view.View.GONE
                tvSkip?.setOnClickListener {
                    WebviewActivity.start(this@SplashActivity, DomainHelper.DefaultWebDomain)
                }
                countDown = DomainHelper.config?.adCountdown ?: 0

                ivSplash?.setOnClickListener {
                    //打开手机默认浏览器
                    val intent =
                        Intent(Intent.ACTION_VIEW, Uri.parse(DomainHelper.config?.adClickUrl))
                    startActivity(intent)
                }
                refreshCountDown()
            }
        }
    }

    private fun refreshCountDown() {
        tvSkip?.text = "跳过 $countDown"
        if (countDown > 0) {
            countDown--
            GlobalScope.launch(Dispatchers.Main) {
                delay(1000)
                refreshCountDown()
            }
        } else {
            WebviewActivity.start(this@SplashActivity, DomainHelper.DefaultWebDomain)
        }
    }


    //使用HttpURLConnection加载图片
    private fun loadImageView(url: String) {
        GlobalScope.launch(Dispatchers.IO) {
            try {
                val conn = URL(url).openConnection() as HttpURLConnection
                conn.connect()
                val inputStream = conn.inputStream
                val bitmap = BitmapFactory.decodeStream(inputStream)
                withContext(Dispatchers.Main) {
                    ivSplash?.setImageBitmap(bitmap)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }
}