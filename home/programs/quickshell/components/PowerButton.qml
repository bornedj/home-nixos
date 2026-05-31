import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import "../"
import "../containers"

RoundedWrapper {
    id: root

    property bool isPowerMenuOpen: true

    Image {
        source: "../assets/power.svg"
        fillMode: Image.PreserveAspectCrop
        scale: 0.8

        MouseArea {
            anchors.fill: parent
            onClicked: root.isPowerMenuOpen = !root.isPowerMenuOpen
        }
    }
}
