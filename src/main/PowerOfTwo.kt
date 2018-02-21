package main

/**
 * Created by zvlades on 9/2/17.
 */

fun main(args: Array<String>) {
    if (args.size == 0) {
        println("power is not specified")
        return
    }
    val exponent: Int? = try { args[0].toInt() } catch (e: NumberFormatException) { null }
    if (exponent != null) {
        println("%.0f".format(Math.pow(2.0, exponent.toDouble())))
    } else {
        println("Wrong argument")
    }
}