package main.utils

/**
 * Created by zvlades on 9/18/17.
 */

val macAddressRegex = Regex("([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})")

internal fun containsMACAddress(str: String): Boolean {
    return macAddressRegex.containsMatchIn(str)
}

internal fun findMACAddressSubstring(inStr: String): String? {
    return macAddressRegex.find(inStr)?.value
}
