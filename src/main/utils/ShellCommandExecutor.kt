// Created by zvlades on 7/30/17.
package main.utils

import java.io.BufferedReader
import java.io.File
import java.io.InputStream
import java.io.InputStreamReader
import java.util.concurrent.Executors
import java.util.function.Consumer
import java.util.stream.Stream

internal fun executeInShell(command: String,
                   nextLineInOutputConsumer: Consumer<String>): Int {
    val builder = ProcessBuilder()
    if (isWindows) {
        builder.command("cmd.exe", "/c", command)
    } else {
        builder.command("sh", "-c", command)
    }
    builder.directory(File(System.getProperty("user.home")))
    val process = builder.start()
    val streamGobbler = StreamGobblerWithItemConsumer(process.inputStream, nextLineInOutputConsumer)
    Executors.newSingleThreadExecutor().submit(streamGobbler)
    val exitCode = process.waitFor()
    return exitCode
}

internal fun executeInShell(command: String,
                   outputStreamConsumer: (Stream<String>) -> Unit ): Int {
    val builder = ProcessBuilder()
    if (isWindows) {
        builder.command("cmd.exe", "/c", command)
    } else {
        builder.command("sh", "-c", command)
    }
    builder.directory(File(System.getProperty("user.home")))
    val process = builder.start()
    val streamGobbler = StreamGobblerWithStreamConsumer(process.inputStream, outputStreamConsumer)
    Executors.newSingleThreadExecutor().submit(streamGobbler)
    val exitCode = process.waitFor()
    return exitCode
}

private class StreamGobblerWithItemConsumer(
        private val inputStream: InputStream,
        private val nextLineInOutputConsumer: Consumer<String>
) : Runnable {

    override fun run() {
        BufferedReader(InputStreamReader(inputStream)).lines()
                .forEach(nextLineInOutputConsumer)
    }
}

private class StreamGobblerWithStreamConsumer(
        private val inputStream: InputStream,
        private val resultStreamCallback: (Stream<String>) -> Unit
) : Runnable {

    override fun run() {
        val stream = BufferedReader(InputStreamReader(inputStream)).lines()
        resultStreamCallback(stream)
    }
}

private var isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows")





/**
 * Sourced from:
 * http://www.baeldung.com/run-shell-command-in-java
 *
 *
 * Other resources:
 *
 * 'getting output from executing a command line program'
 * Tue Sep 19 10:45:56 IDT 2017
 * https://stackoverflow.com/questions/5711084/java-runtime-getruntime-getting-output-from-executing-a-command-line-program
 *
 * 'Retrieving a List from a java.util.stream.Stream in Java 8'
 * Tue Sep 19 10:47:49 IDT 2017
 * https://stackoverflow.com/questions/14830313/retrieving-a-list-from-a-java-util-stream-stream-in-java-8
 */