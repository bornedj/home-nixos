import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import "../containers"
import "../services"
import "../"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            // hide bar when something is fullscreened
            visible: !Hyprland.focusedWorkspace?.hasFullscreen

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: 5
                bottom: 0
            }

            color: "transparent"
            implicitHeight: 30

            RoundedWrapper {
                anchors.centerIn: parent
                Text {
                    text: Time.time
                    color: Colors.md3.primary
                    font {
                        bold: true
                        pixelSize: 14
                    }
                }
            }

            RowLayout {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 7
                }

                PowerButton { id: powerButton }

                RoundedWrapper {
                    Workspaces {}
                }
            }


            SystemStats {}

            PopupWindow {
                anchor.window: bar
                anchor.rect.x: powerButton.x + 7 // margin
                anchor.rect.y: bar.implicitHeight - 2 // overlap with original button
                implicitHeight: powerButton.implicitHeight * 2
                implicitWidth: powerButton.implicitWidth
                visible: powerButton.isPowerMenuOpen
                color: "transparent"

                Rectangle {
                    color: Colors.base16.base01
                    height: parent.height
                    width: parent.width
                    topLeftRadius: 0
                    topRightRadius: 0
                    bottomLeftRadius: 12
                    bottomRightRadius: 12

                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        Repeater {
                            model: [ "../assets/power.svg", "../assets/power.svg"]
                            Image {
                                source: modelData
                                fillMode: Image.PreserveAspectCrop
                                scale: 0.8
                            }
                        }
                    }
                }
            }
        }
    }
}
