package main.utils

import java.util.function.Consumer
import java.util.stream.Stream

/**
 * Created by zvlades on 9/18/17.
 */


internal val commandToGetWiFiNetworksDescriptionTable = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s"

internal fun forEachSSID(actionOnNextSSID: (String) -> Unit) {
    executeInShell(commandToGetWiFiNetworksDescriptionTable, Consumer {
        extractSSID(it)?.let { actionOnNextSSID(it) }
    })
}

internal fun streamSSIDs(streamConsumer: (Stream<String>) -> Unit) {
    executeInShell(commandToGetWiFiNetworksDescriptionTable) {
        streamConsumer(// it == shellOutput
                it.filter { extractSSID(it) != null }
                        .map { extractSSID(it) })
    }
}

internal fun extractSSID(sourceStr: String): String? {
    findMACAddressSubstring(sourceStr)?.let { val macAddressSubstr = it
        sourceStr.indexOf(macAddressSubstr).takeIf { it >= 0 }?.let { val macAddressSubstrStartIndex = it
            val ssid = sourceStr.substring(0, macAddressSubstrStartIndex - 1)
                    .trimStart().trimEnd()
            return ssid
        }
    }
    return null
}
