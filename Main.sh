#!/usr/bin/env zsh

thisFolder="$linuxconfig/ConsoleTools"

source "$zshConfig"/Kotlin.sh
alias kts="kotlinRunScript:SourceFile"
alias kt="kotlinCompileToJar:SourceFile"

alias letterIndex="jarRun:SourceFile $thisFolder/jar/AlphabetIndex.kt.jar"
alias pow2="jarRun:SourceFile $thisFolder/jar/PowerOfTwo.kt.jar"

source "$thisFolder/src/main/applications/Main.sh"