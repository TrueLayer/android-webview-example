package com.example.testredirect

import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.Intent.ACTION_VIEW
import android.content.Intent.CATEGORY_BROWSABLE
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.content.Intent.FLAG_ACTIVITY_REQUIRE_NON_BROWSER
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.webkit.WebResourceRequest
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class WebViewActivity : AppCompatActivity() {

    private lateinit var webView: WebView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_web_view)

        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        // Assuming your view contains a Webview with "myCustomWebView" as Id.
        webView = findViewById(R.id.myCustomWebView)

        // Required to load more than just plain html and css
        val settings: WebSettings = webView.settings
        settings.domStorageEnabled = true
        settings.javaScriptEnabled = true

        webView.webViewClient = webClient

        // Default to a TrueLayer page that can easily "trigger" application links from banks
        val url = intent.getStringExtra("LINK") ?: "https://payment.truelayer-sandbox.com/test-redirect"
        webView.loadUrl(url)
    }

    fun showMessage(message: String?) {
        Toast.makeText(this.applicationContext, message, Toast.LENGTH_SHORT).show()
    }

    private val webClient = object : WebViewClient() {
        override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
            super.onPageStarted(view, url, favicon)
            showMessage(url)
        }

        // Seems to be only calling when top level URL Change
        // but not on original load of the WebView ¯\_(ツ)_/¯
        override fun shouldOverrideUrlLoading(
            view: WebView?,
            request: WebResourceRequest?
        ): Boolean {
            return shouldOverrideUrlLoadingWithBasicIntent(request)
        }

        // Alternatively can also create an override following:
        // Based on https://android.googlesource.com/platform/frameworks/webview/+/4dcabae/chromium/java/com/android/webview/chromium/WebViewContentsClientAdapter.java
        private fun shouldOverrideUrlLoadingWithBasicIntent(
            request: WebResourceRequest?
        ): Boolean {
            val uri = request?.url
            println("shouldOverrideUrlLoading executing....")
            println(uri)
            // replace "truelayer" with whatever host you expect to load within the webview
            if (uri != null && uri.host?.contains("truelayer.com") == false) {
                openUri(uri)
                return true
            }
            return false
        }

        private fun openUri(uri: Uri) {
            try {
                val intent = Intent(ACTION_VIEW, uri).apply {
                    // The URL should either launch directly in a non-browser app (if it's
                    // the default), or in the disambiguation dialog.
                    addCategory(CATEGORY_BROWSABLE)
                    flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        FLAG_ACTIVITY_NEW_TASK or FLAG_ACTIVITY_REQUIRE_NON_BROWSER
                    } else {
                        FLAG_ACTIVITY_NEW_TASK
                    }
                }
                startActivity(intent)
            } catch (e: ActivityNotFoundException) {
                // Only browser apps are available, or a browser is the default.
                // So you will have to open the website
                val intent = Intent(ACTION_VIEW, uri)
                startActivity(intent)
            }
        }
    }
}
