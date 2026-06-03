package com.stsj.sipsales

import android.os.Bundle
import com.google.android.gms.security.ProviderInstaller
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        try {
            ProviderInstaller.installIfNeeded(this)
        } catch (_: Exception) {}
        super.onCreate(savedInstanceState)
    }
}
