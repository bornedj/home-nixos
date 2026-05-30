pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    property int usage: 0
    Process {
        id: memProc
        command: ["zsh", "-c", "free | rg Mem"]
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split(/\s+/);
                var total = parseInt(p[1]) || 1;
                var used = parseInt(p[2]) || 0;

                usage = Math.round(100 * used / total);
            }
            Component.onCompleted: running = true
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: memProc.running = true
    }
}
