------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- sceptre monitor
hl.monitor({
    output   = "DP-6",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})

-- benq horizontal
hl.monitor({
    output   = "DP-5",
    mode     = "1920x1080@144",
    position = "-2160x0@60",
    scale    = 1,
    transform = 1
})
