package com.ui

import android.content.Context
import android.util.Base64
import android.util.Log
import com.google.gson.Gson
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.security.SecureRandom
import java.security.cert.X509Certificate
import javax.net.ssl.HttpsURLConnection
import javax.net.ssl.SSLContext
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager

object DomainHelper {
    var DefaultApiDomain = ""
    var DefaultWebDomain = ""
    var userAgent: String? = ""
    var config: DomainConfig? = null
    var isAbNormal = false


    suspend fun refreshAvailableDomain(context: Context): String? {
        try {
            trustSSl()
            config = readConfig(context)
            if (config == null) {
                config = readConfigFromAssets(context)
                saveConfig(context, config!!)
            }
            log("DomainHelper 获取到可用配置 $config")

            var configApis = config?.configApis

            // configApis更新最新的配置信息，更新缓存
            GlobalScope.launch(kotlinx.coroutines.Dispatchers.IO) {
                configApis?.forEach { configApi ->
                    val configNet = readConfigFromConfigApi(configApi)
                    if (configNet != null) {
                        saveConfig(context, configNet)
                        return@launch
                    }
                }
            }

            if (config == null) return null

            val abUrl = config?.abUrl
            val lastDomain = config?.lastDomain
            var domainList = config?.domainList
            val dnsApis = config?.dnsApis
            configApis = config?.configApis

            lastDomain?.let {
                domainList = domainList?.toMutableList()?.apply { add(0, it) }
            }


            // 遍历测试访问domainList域名列表，获取可用域名列表
            domainList?.forEach { domain ->
                if (testDomainCanAccess(domain)) {
                    config?.lastDomain = domain
                    refreshDomain(domain, config?.userAgent)
                    return@refreshAvailableDomain domain
                }
            }


            // 查看ab是否打开
            if (abUrl.isNullOrEmpty()) {
                isAbNormal = false
            } else {
                dnsApis?.firstOrNull()?.let {
                    isAbNormal = retrieveAbResultFromDnsTextRecord(it, abUrl)
                }
            }

            // 如果没有可用域名，则通过dnsApis遍历domainList获取txt信息，其中txt中存的新域名，获取新域名列表
            dnsApis?.forEach { dnsApi ->
                domainList?.forEach { domain ->
                    val newDomainList = retrieveDomainListFromDnsTextRecord(dnsApi, domain)
                    newDomainList.forEach { newDomain ->
                        if (testDomainCanAccess(newDomain)) {
                            config?.lastDomain = newDomain
                            saveConfig(context, config!!)
                            refreshDomain(newDomain, config?.userAgent)
                            return@refreshAvailableDomain newDomain
                        }
                    }
                }
            }

            // configApis更新最新的配置信息，更新缓存
            configApis?.forEach { configApi ->
                config = readConfigFromConfigApi(configApi)
                if (config != null) {
                    log("DomainHelper 获取备用配置 $config")
                    saveConfig(context, config!!)
                    return@refreshAvailableDomain refreshAvailableDomain(context)
                }
            }
            return config?.domainList?.firstOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }

    private fun refreshDomain(domain: String, userAgent: String?): String {
        DomainHelper.userAgent = userAgent
        DefaultWebDomain = domain
        log("DomainHelper 获取到可用域名 $DefaultWebDomain")
        return DefaultApiDomain
    }

    private suspend fun readConfigFromConfigApi(configApi: String): DomainConfig? {

        return try {
            log("DomainHelper 获取备用配置开始 $configApi")
            try {
                val responseData = requestUrl(configApi)
                log("DomainHelper 获取备用配置 $responseData")
                Gson().fromJson(responseData, DomainConfig::class.java)
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun readConfigFromAssets(context: Context): DomainConfig {
        return try {
            val content =
                context.assets.open("domain_config.json").bufferedReader()
                    .use { it.readText() }

            if (content.contains("{")) {
                Gson().fromJson(content, DomainConfig::class.java)
            } else {
                val decodedContent = String(Base64.decode(content, Base64.DEFAULT))
                Gson().fromJson(decodedContent, DomainConfig::class.java)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            DomainConfig("", "", "", 0, "", "", emptyList(), emptyList(), emptyList(), emptyList())
        }
    }

    private fun saveConfig(context: Context, config: DomainConfig) {
        val sharedPreferences = context.getSharedPreferences("domain_config", Context.MODE_PRIVATE)
        sharedPreferences.edit().putString("domain_config", Gson().toJson(config)).apply()
    }

    private fun readConfig(context: Context): DomainConfig? {
        val sharedPreferences = context.getSharedPreferences("domain_config", Context.MODE_PRIVATE)
        val configJson = sharedPreferences.getString("domain_config", null)
        return configJson?.let { Gson().fromJson(it, DomainConfig::class.java) }
    }

    private suspend fun retrieveDomainListFromDnsTextRecord(
        dnsApiUrl: String,
        domain: String
    ): List<String> {
        val dnsApi = dnsApiUrl.replace("{domain}", domain).replace("{dnsType}", "TXT")
        return try {
            val data = requestUrl(dnsApi)
            log("DomainHelper 获取txt解析结果 $data")
            val domainList = mutableListOf<String>()
            val jsonData = Gson().fromJson(data, Map::class.java)
            if (jsonData["Status"] == 0.0) {
                val answers = jsonData["Answer"] as List<Map<String, String>>
                answers.forEach { answer ->
                    extractDomainFromText(answer["data"] ?: "").forEach { domainList.add(it) }
                }
                domainList.distinct()
            } else emptyList()
        } catch (e: Exception) {
            emptyList()
        }
    }

    suspend fun retrieveAbResultFromDnsTextRecord(dnsApiUrl: String, domain: String): Boolean {
        val dnsApi = dnsApiUrl.replace("{domain}", domain).replace("{dnsType}", "TXT")
        return try {
            val data = requestUrl(dnsApi)
            log("DomainHelper 获取txt解析结果 $data")
            val jsonData = Gson().fromJson(data, Map::class.java)
            val answers = jsonData["Answer"] as List<Map<String, String>>?
            return answers?.any { it["data"]?.contains("ab_normal") == true } == true
        } catch (e: Exception) {
            false
        }
    }

    suspend fun extractDomainFromText(text: String): List<String> {
        log("DomainHelper 开始提取域名 $text")
        val domainList = mutableListOf<String>()
        val regex = Regex("(http|https)://[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+")
        regex.findAll(text).forEach { matchResult ->
            matchResult.value.let { domain ->
                log("DomainHelper 提取域名 $domain")
                domainList.add(domain)
            }
        }
        return domainList
    }

    suspend fun testDomainCanAccess(domain: String): Boolean {
        log("DomainHelper 检验域名是否可以访问 $domain")
        return try {
            if (domain.isEmpty()) {
                false
            } else {
                try {
                    requestUrl(domain)
                    return true
                } catch (e: Exception) {
                    return false
                }

            }
        } catch (e: Exception) {
            false
        }
    }


    /**
     * 使用HttpURLConnection请求url
     */
    suspend fun requestUrl(url: String): String {
        try {
            val connection = URL(url).openConnection() as HttpURLConnection
            connection.connectTimeout = 5000
            connection.readTimeout = 5000
            connection.requestMethod = "GET"
            connection.connect()
            val responseCode = connection.responseCode
            if (responseCode == HttpURLConnection.HTTP_OK) {
                val inputStream = connection.inputStream
                val reader = BufferedReader(InputStreamReader(inputStream))
                val response = StringBuilder()
                var line: String?
                while (reader.readLine().also { line = it } != null) {
                    response.append(line)
                }
                reader.close()
                inputStream.close()
                connection.disconnect()
                return response.toString()
            } else {
                connection.disconnect()
                throw Exception("HttpURLConnection request failed")
            }
        } catch (e: Exception) {
            throw Exception("HttpURLConnection request failed")
        }
    }

    private fun log(message: String) {
        Log.e("DomainHelper", message)
    }

    private fun trustSSl() {
        try {
            val trustAllCerts: Array<TrustManager> = arrayOf(
                object : X509TrustManager {
                    override fun checkClientTrusted(
                        chain: Array<out X509Certificate>?,
                        authType: String?
                    ) {
                    }

                    override fun checkServerTrusted(
                        chain: Array<out X509Certificate>?,
                        authType: String?
                    ) {
                    }

                    override fun getAcceptedIssuers(): Array<X509Certificate> {
                        return arrayOf()
                    }
                }
            )
            val sslContext = SSLContext.getInstance("SSL")
            sslContext.init(null, trustAllCerts, SecureRandom())
            HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.socketFactory)
            HttpsURLConnection.setDefaultHostnameVerifier { _, _ -> true }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}