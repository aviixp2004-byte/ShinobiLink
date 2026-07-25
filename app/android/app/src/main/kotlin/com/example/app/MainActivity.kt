package com.example.app

import android.content.Context
import android.content.IntentFilter
import android.net.wifi.p2p.WifiP2pManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val METHOD_CHANNEL = "shinobilink/wifi_direct"
    private val EVENT_CHANNEL = "shinobilink/wifi_direct/events"

    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

    private var wifiP2pManager: WifiP2pManager? = null
    private var wifiChannel: WifiP2pManager.Channel? = null
    private var receiver: WifiDirectReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {

            override fun onListen(
                arguments: Any?,
                events: EventChannel.EventSink?
            ) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "initialize" -> {

                    wifiP2pManager =
                        getSystemService(Context.WIFI_P2P_SERVICE)
                                as WifiP2pManager

                    wifiChannel =
                        wifiP2pManager?.initialize(
                            this,
                            mainLooper,
                            null
                        )

                    receiver = WifiDirectReceiver(
                        wifiP2pManager,
                        wifiChannel
                    )

                    val filter = IntentFilter().apply {
                        addAction(WifiP2pManager.WIFI_P2P_STATE_CHANGED_ACTION)
                        addAction(WifiP2pManager.WIFI_P2P_PEERS_CHANGED_ACTION)
                        addAction(WifiP2pManager.WIFI_P2P_CONNECTION_CHANGED_ACTION)
                        addAction(WifiP2pManager.WIFI_P2P_THIS_DEVICE_CHANGED_ACTION)
                    }

                    registerReceiver(receiver, filter)

                    result.success(wifiChannel != null)
                }

                "discoverPeers" -> {

                    val manager = wifiP2pManager
                    val channel = wifiChannel

                    if (manager == null || channel == null) {
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    manager.discoverPeers(
                        channel,
                        object : WifiP2pManager.ActionListener {
                            override fun onSuccess() {
                                result.success(true)
                            }

                            override fun onFailure(reason: Int) {
                                result.success(false)
                            }
                        }
                    )
                }

                "connect" -> {
                    result.success(true)
                }

                "disconnect" -> {
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        receiver?.let {
            unregisterReceiver(it)
        }
        super.onDestroy()
    }
}
