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
            color: Colors.md3.on_surface_variant
            font {
                bold: true
                pixelSize: 14
            }
        }
    }

    RoundedWrapper {
        Text {
            text: "GPU: " + Gpu.usage
            color: Colors.md3.on_surface
            font {
                bold: true
                pixelSize: 14
            }
        }
    }

    RoundedWrapper {
        Text {
            text: "Mem: " + Mem.usage + "%"
            color: Colors.md3.surface_tint
            font {
                bold: true
                pixelSize: 14
            }
        }
    }
}
