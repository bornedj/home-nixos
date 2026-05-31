return {
    image = "{{image}}",

    md3 = {
    <* for name, value in colors *>
        {{name}} = "{{value.default.hex}}",
    <* endfor *>
    },

    base16 = {
    <* for name, value in base16 *>
        {{name}} = "{{value.default.hex}}",
    <* endfor *>
    }
}
