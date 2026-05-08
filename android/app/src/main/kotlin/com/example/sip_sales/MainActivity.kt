package com.stsj.sipsales

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import org.conscrypt.Conscrypt
import java.security.Security

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        Security.insertProviderAt(Conscrypt.newProvider(), 1)
        super.onCreate(savedInstanceState)
    }
}
