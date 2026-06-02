import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import "../"

WrapperRectangle {
    id: root

    property bool isPowerMenuOpen: false

    color: Colors.base16.base01

    topLeftRadius: 12
    topRightRadius: 12
    bottomLeftRadius: isPowerMenuOpen ? 0 : 12
    bottomRightRadius: isPowerMenuOpen ? 0 : 12
    
    margin: 5

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
