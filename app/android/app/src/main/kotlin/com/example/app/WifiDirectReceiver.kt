package com.example.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.wifi.p2p.WifiP2pManager

class WifiDirectReceiver(
    private val manager: WifiP2pManager?,
    private val channel: WifiP2pManager.Channel?,
) : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {

        when (intent?.action) {

            WifiP2pManager.WIFI_P2P_PEERS_CHANGED_ACTION -> {

                if (manager == null || channel == null) return

                manager.requestPeers(channel) { peers ->

                    val devices = peers.deviceList.map {

                        mapOf(
                            "name" to it.deviceName,
                            "address" to it.deviceAddress,
                        )

                    }

                    MainActivity.eventSink?.success(devices)
                }
            }
        }
    }
}
