import QtQuick
import QtQuick
import QtQuick.Layouts
import "../"
import "../services"
import "../containers"

RowLayout {
    anchors {
        right: parent.right
        verticalCenter: parent.verticalCenter
        rightMargin: 7
    }

    RoundedWrapper {
        Text {
            text: "CPU: " + Cpu.usage + "%"
            color: Colors.base04
            font {
                bold: true
                pixelSize: 14
            }
        }
    }

    RoundedWrapper {
        Text {
            text: "GPU: " + Gpu.usage
            color: Colors.base0c
            font {
                bold: true
                pixelSize: 14
            }
        }
    }

    RoundedWrapper {
        Text {
            text: "Mem: " + Mem.usage + "%"
            color: Colors.base0e
            font {
                bold: true
                pixelSize: 14
            }
        }
    }
}
