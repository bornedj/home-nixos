pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
    property string usage: "0%"

    Process {
        id: gpuProc
        command: ["zsh", "-c", "nvidia-smi --query-gpu utilization.gpu | sed -n '2p'"]
        stdout: SplitParser {
            onRead: data => {
                usage = data.trim()
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: gpuProc.running = true
    }
}
