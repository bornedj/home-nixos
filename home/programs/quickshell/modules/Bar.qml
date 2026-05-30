import Quickshell
import Quickshell.Hyprland

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      color: Colors.base01
      // hide bar when something is fullscreened
      visible: !Hyperland.focusedWorkspace.hasFullscreen

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30

      ClockWidget {
        anchors.centerIn: parent
      }

      Workspaces {}
    }
  }
}
