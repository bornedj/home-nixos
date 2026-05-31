import QtQuick
import QtQuick
import QtQuick.Layouts
import "../services"
import "../containers"
import "../"

RowLayout {
    anchors {
        right: parent.right
        verticalCenter: parent.verticalCenter
        rightMargin: 7
    }

    RoundedWrapper {
        Text {
            text: "CPU: " + Cpu.usage + "%"
            color: Colors.base16.base05
            font {
                bold: true
                pixelSize: 14
            }
        }
    }

    RoundedWrapper {
        Text {
            text: "GPU: " + Gpu.usage
            color: Colors.md3.primary
            font {
                bold: true
                pixelSize: 14
            }
        }
    }

    RoundedWrapper {
        Text {
            text: "Mem: " + Mem.usage + "%"
            color: Colors.md3.tertiary
            font {
                bold: true
                pixelSize: 14
            }
        }
    }
}
