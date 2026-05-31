import QtQuick
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

            RoundedWrapper {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 7
                }
                Workspaces {}
            }

            SystemStats {}
        }
    }
}
