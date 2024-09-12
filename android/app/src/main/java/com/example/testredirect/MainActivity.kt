package com.example.testredirect

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.browser.customtabs.CustomTabsIntent

class MainActivity : AppCompatActivity() {

    private lateinit var textInput: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val customTabButton = findViewById<Button>(R.id.loadCustomTabButton)
        customTabButton.setOnClickListener {
            loadCustomTab(getLink())
        }

        val webViewButton = findViewById<Button>(R.id.loadWebViewButton)
        webViewButton.setOnClickListener {
            loadWebView(getLink())
        }

        val browserButton = findViewById<Button>(R.id.browserButton)
        browserButton.setOnClickListener {
            openInBrowser(getLink())
        }

        textInput = findViewById(R.id.edit_text_link)
        // Default to a TrueLayer page that can easily "trigger" application links from banks
        textInput.setText("https://payment.truelayer-sandbox.com/test-redirect", TextView.BufferType.EDITABLE)
    }

    private fun loadWebView(link: String) {
        val intent = Intent(this, WebViewActivity::class.java).apply {
            putExtra("LINK", link)
        }
        startActivity(intent)
    }

    // This is recommended only for GBP payments where the majority of providers support App2App
    private fun loadCustomTab(url: String) {
        try {
            // Attempts to start custom tab with Google Chrome
            val builder = CustomTabsIntent.Builder()
            val customTabsIntent = builder.build()
            customTabsIntent.intent.setPackage("com.android.chrome")
            customTabsIntent.launchUrl(this, Uri.parse(url))
        } catch (e: Exception) {
            // If Google Chrome isn't available then uses the default browser
            val builder = CustomTabsIntent.Builder()
            val customTabsIntent = builder.build()
            customTabsIntent.launchUrl(this, Uri.parse(url))
        }
    }

    private fun openInBrowser(url: String) {
        try {
            // Attempts to open in Google Chrome
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            intent.setPackage("com.android.chrome")
            startActivity(intent)
        } catch (e: Exception) {
            // If Google Chrome isn't available then uses the default browser
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            startActivity(intent)
        }
    }

    private fun getLink(): String {
        return textInput.text.toString()
    }
}
