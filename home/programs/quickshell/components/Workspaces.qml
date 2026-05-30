import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../" // imports the Colors file

RowLayout {
  anchors.margins: 8

  Repeater {
      model: 10

      Text {
          property var ws: Hyprland.workspaces.values.find(w => w.id == index + 1)
          property var isActive: Hyprland.focusedWorkspace?.id == (index + 1)

          text: index + 1
          color: isActive ? Colors.base0c : (ws ? Colors.base0d : Colors.base0a)
          font { pixelSize: 14; bold: true }

          MouseArea {
              anchors.fill: parent
              onClicked: Hyprland.dispatch(`hl.dsp.focus({workspace = "${index + 1}"})`)
          }
      }
  }
}
