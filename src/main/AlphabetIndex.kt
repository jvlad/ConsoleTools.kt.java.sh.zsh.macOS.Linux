package main

import main.utils.cprintln

/**
 * Created by zvlades on 9/2/17.
 */

fun main(args: Array<String>) {
    findLetterIndexInAlphabet(args)
}

private fun findLetterIndexInAlphabet(args: Array<String>) {
    if (args.size == 0) {
        cprintln("main.findLetterIndexInAlphabet: no arguments passed")
        return
    }

    val letter: String = args[0].toLowerCase()
    val alphabet = arrayOf("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
    val index = alphabet.indexOf(letter)
    val result = if (index != -1)
        "${index + 1}"
        else "`$letter` is not letter in alphabet"
    cprintln(result)
}
