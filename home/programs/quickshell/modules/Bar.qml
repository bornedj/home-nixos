import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import "barwidgets"

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
          ClockWidget {}
      }

      RoundedWrapper {
          anchors {
              left: parent.left
              verticalCenter: parent.verticalCenter
              leftMargin: 5
          }
          Workspaces {}
      }
    }
  }
}
