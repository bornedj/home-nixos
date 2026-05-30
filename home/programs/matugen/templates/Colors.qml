pragma Singleton

import Quickshell

Singleton {
    <* for name, value in base16 *>
    readonly property string {{ name }}: "{{value.default.hex}}"
    <* endfor *>
}
