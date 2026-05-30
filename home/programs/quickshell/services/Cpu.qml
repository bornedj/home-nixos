pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

Singleton {
    property int usage: 0
    property real lastCpuIdle: 0
    property real lastCpuTotal: 0

    Process {
        id: cpuProc
        command: ["zsh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split(/\s+/);
                var idle = parseInt(p[4]) + parseInt(p[5]);
                var total = p.slice(1).reduce((a, b) => a + parseInt(b), 0);

                if (lastCpuTotal > 0) {
                    usage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));
                }
                lastCpuTotal = total;
                lastCpuIdle = idle;
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }
}
