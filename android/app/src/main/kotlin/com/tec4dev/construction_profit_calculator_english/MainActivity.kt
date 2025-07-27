package com.tec4dev.construction_profit_calculator_english

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge() // Enable edge-to-edge display
    }

    private fun enableEdgeToEdge() {
        // Use WindowCompat to manage window insets for edge-to-edge display
        WindowCompat.setDecorFitsSystemWindows(window, false) // Allow content to extend into system windows
    }

    // Optionally, you can override configureFlutterEngine if needed for additional setup
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Additional configuration can be added here if needed
    }
}
