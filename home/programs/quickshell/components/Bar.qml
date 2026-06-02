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
                    Workspaces { id: workspaces }
                }
            }


            SystemStats {}

            PopupWindow {
                anchor.window: bar
                anchor.rect.x: powerButton.x + 7 // margin
                anchor.rect.y: bar.implicitHeight
                implicitHeight: powerButton.implicitHeight * 2
                implicitWidth: powerButton.implicitWidth + workspaces.implicitWidth
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

                    ColumnLayout {
                        anchors.horizontalCenter: parent.horizontalCenter

                        RowLayout {
                            Text { 
                                font {
                                    pixelSize: 14
                                    family: "Maple Mono NF"
                                    bold: true
                                }
                                color: Colors.md3.primary
                                text: "Restart"
                            }
                            Image {
                                source: "../assets/power.svg"
                                fillMode: Image.PreserveAspectCrop
                                scale: 0.8
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Restart")
                            }
                        }

                        RowLayout {
                            Text { 
                                font {
                                    pixelSize: 14
                                    family: "Maple Mono NF"
                                    bold: true
                                }
                                color: Colors.md3.tertiary
                                text: "Shutdown"
                            }
                            Image {
                                source: "../assets/power.svg"
                                fillMode: Image.PreserveAspectCrop
                                scale: 0.8
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: console.log("Shutdown")
                            }
                        }
                    }
                }
            }
        }
    }
}
