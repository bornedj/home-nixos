local lombok_jar = vim.iter(vim.fn.glob(vim.env.HOME .. '/.m2/repository/org/projectlombok/lombok/*/lombok-*.jar', false, true)):last()

local cmd = vim.iter({
    require("bornedj.generated").jdtls_cmd,
    lombok_jar and ('--jvm-arg=-javaagent:' .. lombok_jar) or nil,
}):totable()

return {
    cmd = cmd,
    root_markers = { 'gradlew', '.git', 'mvnw', 'pom.xml' },
    init_options = {
        bundles = {
            vim.fn.glob(
                '~/.local/lib/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'),
        }
    },
    settings = {
        java = {
            configuration = {
            },
            completion = {
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*", "sun.*",
                }
            },
            jdt = {
                ls = {
                    lombokSupport = {
                        enabled = true
                    }
                }
            }
        }
    },
}
