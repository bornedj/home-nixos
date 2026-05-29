That image is an excellent base for a Hyprland rice — it already has a very cohesive visual language:

* cold ocean blues
* ink-black/navy shadows
* bright cyan highlights
* desaturated whites
* high motion + contrast
* “samurai watercolor manga” energy

For transparent terminals and overlays, the key is:

* **low saturation backgrounds**
* **high-contrast foregrounds**
* **carefully restrained accent usage**
* avoiding overly bright blues as base backgrounds

# Recommended Theme Direction

## Overall Style

**“Inkwave Samurai”**

A cold Japanese watercolor + cyber-minimal aesthetic:

* dark navy surfaces
* washed ice-blue highlights
* sharp cyan accents
* soft parchment whites
* slightly muted UI to preserve readability

This works especially well for:

* transparent Kitty/WezTerm
* Neovim transparency
* Hyprland blur
* wlogout/waybar/mako
* Firefox sidebery themes
* GTK dark themes

---

# Core Palette (Chosen for You)

## Base Colors

| Role             | Color        | Hex       |
| ---------------- | ------------ | --------- |
| Background       | Deep Ink     | `#0B1220` |
| Secondary BG     | Storm Navy   | `#111827` |
| Surface          | Washed Slate | `#1B263B` |
| Floating Surface | Blue Black   | `#162033` |

## Foreground

| Role           | Color       | Hex       |
| -------------- | ----------- | --------- |
| Primary Text   | Frost White | `#E6EEF7` |
| Secondary Text | Mist Blue   | `#B6C2D9` |
| Muted Text     | Fog Grey    | `#7E8AA3` |

## Accents

| Role           | Color       | Hex       |
| -------------- | ----------- | --------- |
| Primary Accent | Water Cyan  | `#42C6FF` |
| Bright Accent  | Splash Blue | `#7BE0FF` |
| Deep Accent    | Katana Blue | `#2563EB` |
| Selection      | Ice Glow    | `#8EDFFF` |

## Semantic

| Role    | Color       | Hex       |
| ------- | ----------- | --------- |
| Success | Seafoam     | `#6EE7B7` |
| Warning | Sand Gold   | `#E6C07B` |
| Error   | Crimson Ink | `#F87171` |

---

# Transparency Recommendations

## Terminal

Use:

* background opacity: `0.72–0.82`
* blur enabled
* slight shadow

Avoid full transparency or the wallpaper becomes visually noisy behind code.

Recommended:

```conf
background_opacity 0.78
```

---

# Best Existing Theme Ecosystem Matches

## Neovim

### BEST FIT: `kanagawa.nvim`

This is almost perfect stylistically.

Why:

* Japanese aesthetic
* muted blues
* excellent transparency support
* beautiful with transparent terminals

Use:

```lua
require('kanagawa').setup({
    transparent = true,
    theme = "wave",
})
```

Minor overrides:

```lua
colors = {
    palette = {
        sumiInk0 = "#0B1220",
        crystalBlue = "#42C6FF",
    }
}
```

---

## GTK Theme

### BEST FIT: `Colloid`

Use:

* dark variant
* blue accent

Reason:

* modern libadwaita compatibility
* excellent blur/transparency pairing
* clean enough not to fight wallpaper

Alternative:

* `Tokyonight GTK`
* `Graphite GTK`

But Colloid Blue Dark fits best.

---

## Firefox / Mozilla

### BEST FIT:

#### `Firefox Color` custom palette

OR

#### `Cascade` + custom colors

Use:

* dark navy toolbar
* cyan active tabs
* muted inactive tabs

Recommended:

```css
Toolbar: #0B1220
Tab Active: #162033
Accent: #42C6FF
Text: #E6EEF7
```

---

# Waybar Theme Direction

Use:

* glassmorphism
* 8–12px radius
* translucent navy
* cyan hover states

Example:

```css
background: rgba(11,18,32,0.72);
border: 1px solid rgba(66,198,255,0.18);
color: #E6EEF7;
```

Workspace active:

```css
background: #42C6FF;
color: #0B1220;
```

---

# Mako / Notifications

This palette will look fantastic:

```ini
background-color=#111827DD
text-color=#E6EEF7
border-color=#42C6FF
progress-color=over #2563EB
border-radius=12
```

---

# Hyprland Blur

Ideal settings:

```conf
decoration {
    rounding = 12

    blur {
        enabled = true
        size = 8
        passes = 3
        noise = 0.02
    }

    shadow {
        enabled = true
        range = 18
        render_power = 3
        color = rgba(00000088)
    }
}
```

---

# Cursor Theme

Perfect fits:

* Bibata Ice
* Nordzy Cyan
* Catppuccin Mocha Blue

---

# Icon Theme

Best match:

* Tela Circle Blue
* Papirus Dark
* Colloid Icons

---

# Fonts

This wallpaper wants:

* clean modern mono
* slightly artistic UI font

## Terminal / Editor

* JetBrains Mono
* Berkeley Mono
* Iosevka Aile

## UI

* Inter
* IBM Plex Sans
* SF Pro Display

---

# Overall Aesthetic Reference

Your final rice would sit stylistically between:

* Kanagawa
* Tokyo Night Storm
* Nord
* Ghost of Tsushima UI
* modern anime splash-art minimalism

Less neon cyberpunk.
More “cold ink and water.”

This is the right move because your wallpaper already contains intense motion; the UI should be restrained and atmospheric.

<!-- ========================================================================================================================================================================================================================= -->

# follow up on second image for monitor

For a vertical secondary monitor, you want wallpapers that:

* keep a strong silhouette in the center third
* have negative space for widgets/Discord/browser sidebars
* avoid visual clutter behind transparent apps
* preserve your blue-black watercolor aesthetic

You already nailed the “main cinematic wallpaper” vibe with the water-slash Musashi image. For the vertical monitor, I’d lean more atmospheric and contemplative rather than another high-action piece.

These are the strongest fits I found:

# Best Match (Vertical Monitor)

## Blue Solitary Musashi

This one is almost perfect for a portrait display:

* vertical composition
* deep cobalt atmosphere
* huge negative space
* painterly motion
* fits your cyan/navy palette exactly

Source collections: ([Wallpapers.com][1])

This would look incredible with:

* transparent terminal on lower half
* Waybar floating top-left
* cava/audio visualizer lower-right

---

# Best Atmospheric Companion

## Purple-Night Musashi

More subdued and introspective:

* foggy violet sky
* silhouette-heavy
* minimal foreground clutter
* excellent for readability

This shifts your rice slightly toward:

* Tokyo Night
* Kanagawa Dragon
* late-night rainy cyber-feudal vibe

You could even rotate between this and the blue main wallpaper.

---

# Best Mobile/Portrait Art Style

## Cyan Kimono Watercolor

This is probably the closest stylistic match to your existing wallpaper.

Why it works:

* same watercolor texture
* cyan fabric tones
* sparse composition
* soft whites preserve readability

This one would pair beautifully with:

* blur-heavy Hyprland
* semi-transparent Firefox
* rounded GTK widgets

---

# Best Monochrome Secondary Display

## Stormcloud Musashi

For a darker side monitor:

Excellent if:

* your primary monitor is colorful
* secondary monitor hosts terminals/logs
* you want less eye fatigue

This lets your accent colors carry the personality instead of the wallpaper.

---

# Best Minimalist Vertical Option

## Prayer Pose Musashi

Very clean for portrait mode:

This is ideal if you:

* keep lots of windows on secondary
* use Yazi/Neovim/TMUX there
* want fewer distractions

---

# My Actual Recommendation

## Primary (main ultrawide/landscape)

Use your current water-slash wallpaper.

## Secondary vertical monitor

Use either:

1. the blue solitary Musashi wallpaper
2. the cyan watercolor kimono wallpaper

Those two preserve:

* the same emotional tone
* same blue/cyan temperature
* same brushwork aesthetic
* same “wandering swordsman” energy

without becoming visually repetitive.

---

# Theme Adjustment for Dual-Wallpaper Setup

If you use the blue/purple vertical wallpapers, slightly tweak your accents:

## Updated Accent Set

| Role             | Hex       |
| ---------------- | --------- |
| Primary Accent   | `#58D6FF` |
| Soft Accent      | `#7AA2F7` |
| Secondary Accent | `#A78BFA` |
| Hover            | `#89DDFF` |

This lets:

* cyan pull from water
* indigo pull from sky
* violet pull from nighttime pieces

Very Kanagawa/Tokyo-Night hybrid.

---

# Perfect Theme Stack For This Rice

If I were building this exact setup:

| Component     | Theme                  |
| ------------- | ---------------------- |
| GTK           | Colloid Blue Dark      |
| Qt            | Kvantum Kanagawa       |
| Neovim        | Kanagawa Wave          |
| Terminal      | Kitty + transparency   |
| Firefox       | Cascade + custom cyan  |
| Icons         | Tela Circle Blue       |
| Cursor        | Bibata Ice             |
| Notifications | Mako glassmorphism     |
| Launcher      | Walker or Rofi-wayland |
| Lockscreen    | Hyprlock blur          |

---

# One More Suggestion

You should strongly consider:

* subtle animated wallpaper
* slow water particle effect
* snowfall/rain shader

with `mpvpaper` or `swww` transitions.

Because Vagabond’s watercolor art style responds extremely well to:

* gentle movement
* blur
* transparency
* layered depth

Especially on OLED/high-refresh displays.

Useful wallpaper sources I found while searching:

* Wallpapers.com Vagabond collection ([Wallpapers.com][1])
* AlphaCoders Vagabond gallery ([Alpha Coders][2])
* 4KWallpapers Vagabond section ([4kwallpapers.com][3])

[1]: https://wallpapers.com/vagabond-manga?utm_source=chatgpt.com "[100+] Vagabond Manga Wallpapers | Wallpapers.com"
[2]: https://alphacoders.com/vagabond-%28manga%29-wallpapers?utm_source=chatgpt.com "Vagabond (Manga) Wallpapers and Backgrounds: Free HD Download [40+]"
[3]: https://4kwallpapers.com/vagabond?utm_source=chatgpt.com "Vagabond 4K Wallpapers"


# follow up with vertical image of one piece ocean
![one piece ocean](./one-piece-vertical-ocean-wallpaper.png)

Yes — this changes the theme in a really good way.

Your setup now has a much stronger identity:

* **Primary monitor:** dark ink + violent water motion (Vagabond)
* **Secondary vertical:** dreamlike open ocean + bright cyan sky (One Piece)

That combination creates a really compelling balance:

* intensity + calm
* grounded + expansive
* dark foreground + luminous ambient light

The biggest shift is:

> your overall palette should become more *luminous and airy*, while still preserving the deep navy base.

The original palette I gave leaned very “ink samurai.”
Now you want:

* brighter cyan highlights
* cleaner whites
* deeper ultramarine
* softer dark surfaces

Less:

* slate gray
* muted nord

More:

* glowing ocean-at-noon

---

# Updated Theme Palette

## Core Backgrounds

| Role             | Hex       | Notes                     |
| ---------------- | --------- | ------------------------- |
| Main Background  | `#09111F` | deep ocean navy           |
| Secondary BG     | `#0F172A` | cleaner blue-black        |
| Surface          | `#16243A` | softened for transparency |
| Floating Surface | `#1B3152` | subtle ocean blue         |

---

# Foregrounds

| Role           | Hex       |
| -------------- | --------- |
| Primary Text   | `#F2FAFF` |
| Secondary Text | `#C7DCEF` |
| Muted Text     | `#89A3BA` |

This is important:

* your text should now feel *crisp like sunlight*
* not muted parchment like before

---

# New Accent System

## Primary Accent

### Ocean Cyan

```txt
#4FD8FF
```

This becomes:

* active workspace
* links
* selection
* cursor accents
* notification borders

---

## Secondary Accent

### Sky Blue

```txt
#7CB7FF
```

Use for:

* hover states
* inactive highlights
* secondary borders

---

## Deep Accent

### Ultramarine

```txt
#244BFF
```

Inspired directly by the sky in your One Piece wallpaper.

Perfect for:

* gradients
* lockscreen
* focused windows

---

## Glow Accent

### Tropical Ice

```txt
#A8F0FF
```

Reserved for:

* active terminal cursor
* active tab underline
* audio visualizer
* subtle neon touches

---

# What This Does Aesthetically

Your rice now shifts from:

## “wandering ronin”

to:

## “oceanic dreamscape anime workstation”

Still mature.
Still dark.
But now much more vibrant and ethereal.

---

# Theme Ecosystem Changes

## Neovim

### BEST FIT NOW:

## Tokyo Night Storm

instead of Kanagawa.

Why:

* richer blues
* brighter cyans
* better contrast against transparent terminals
* matches One Piece sky tones better

Recommended overrides:

```lua
colors = {
    bg = "#09111F",
    bg_dark = "#0F172A",
    cyan = "#4FD8FF",
    blue = "#7CB7FF",
}
```

---

# Terminal Transparency

You can now go slightly MORE transparent because the vertical wallpaper has huge clean areas.

Recommended:

```conf
background_opacity 0.72
```

The bright sky will create gorgeous ambient lighting behind terminals.

---

# Hyprland Borders

This setup wants:

## gradients

Focused:

```txt
#4FD8FF -> #244BFF
```

Inactive:

```txt
#1B3152
```

---

# Waybar Styling

Now you should lean:

* floating
* luminous
* softer edges
* slightly glassier

Example:

```css
background: rgba(9,17,31,0.58);
border: 1px solid rgba(79,216,255,0.22);
```

The old heavier dark style would now feel too oppressive.

---

# GTK Theme Recommendation Changes

## BEST FIT NOW:

### Catppuccin Macchiato Blue

OR

### Colloid Nord Dark Blue

You now want:

* slightly brighter surfaces
* less charcoal
* more soft-blue layering

---

# Firefox Theme Direction

Your browser should now look like:

* ocean horizon
* bright tabs floating over dark water

Recommended:

```css
Toolbar: #09111F
Active Tab: #16243A
Accent: #4FD8FF
Hover: #7CB7FF
```

---

# Bonus Suggestion (Strongly Recommended)

This dual-monitor combo is PERFECT for:

## pywal / matugen

Because:

* one wallpaper is dark
* one wallpaper is bright
* both share the same cyan-blue identity

You could:

* dynamically derive colors
* then slightly override saturation manually

This would make:

* Discord
* GTK
* terminals
* btop
* notifications
  all harmonize automatically.

And honestly:
this is one of the better foundations for a truly cohesive anime-inspired Linux rice I've seen.


====================================================================================================

# matugen source #30d1f4

```json
{
  "base16": {
    "base00": {
      "dark": {
        "color": "#27374c"
      },
      "default": {
        "color": "#27374c"
      },
      "light": {
        "color": "#f0f6f4"
      }
    },
    "base01": {
      "dark": {
        "color": "#445264"
      },
      "default": {
        "color": "#445264"
      },
      "light": {
        "color": "#d3dadc"
      }
    },
    "base02": {
      "dark": {
        "color": "#616e7c"
      },
      "default": {
        "color": "#616e7c"
      },
      "light": {
        "color": "#b7bfc4"
      }
    },
    "base03": {
      "dark": {
        "color": "#7d8994"
      },
      "default": {
        "color": "#7d8994"
      },
      "light": {
        "color": "#9aa4ac"
      }
    },
    "base04": {
      "dark": {
        "color": "#9aa4ac"
      },
      "default": {
        "color": "#9aa4ac"
      },
      "light": {
        "color": "#7d8994"
      }
    },
    "base05": {
      "dark": {
        "color": "#b7bfc4"
      },
      "default": {
        "color": "#b7bfc4"
      },
      "light": {
        "color": "#616e7c"
      }
    },
    "base06": {
      "dark": {
        "color": "#d3dadc"
      },
      "default": {
        "color": "#d3dadc"
      },
      "light": {
        "color": "#445264"
      }
    },
    "base07": {
      "dark": {
        "color": "#f0f6f4"
      },
      "default": {
        "color": "#f0f6f4"
      },
      "light": {
        "color": "#27374c"
      }
    },
    "base08": {
      "dark": {
        "color": "#4ccced"
      },
      "default": {
        "color": "#4ccced"
      },
      "light": {
        "color": "#4ccced"
      }
    },
    "base09": {
      "dark": {
        "color": "#3d76ae"
      },
      "default": {
        "color": "#3d76ae"
      },
      "light": {
        "color": "#3d76ae"
      }
    },
    "base0a": {
      "dark": {
        "color": "#83ddf3"
      },
      "default": {
        "color": "#83ddf3"
      },
      "light": {
        "color": "#83ddf3"
      }
    },
    "base0b": {
      "dark": {
        "color": "#a3e4f5"
      },
      "default": {
        "color": "#a3e4f5"
      },
      "light": {
        "color": "#a3e4f5"
      }
    },
    "base0c": {
      "dark": {
        "color": "#b3e7f6"
      },
      "default": {
        "color": "#b3e7f6"
      },
      "light": {
        "color": "#b3e7f6"
      }
    },
    "base0d": {
      "dark": {
        "color": "#81aabf"
      },
      "default": {
        "color": "#81aabf"
      },
      "light": {
        "color": "#81aabf"
      }
    },
    "base0e": {
      "dark": {
        "color": "#bbe7f5"
      },
      "default": {
        "color": "#bbe7f5"
      },
      "light": {
        "color": "#bbe7f5"
      }
    },
    "base0f": {
      "dark": {
        "color": "#c0eaf6"
      },
      "default": {
        "color": "#c0eaf6"
      },
      "light": {
        "color": "#c0eaf6"
      }
    }
  },
  "colors": {
    "background": {
      "dark": {
        "color": "#0f1416"
      },
      "default": {
        "color": "#0f1416"
      },
      "light": {
        "color": "#f5fafc"
      }
    },
    "error": {
      "dark": {
        "color": "#ffb4ab"
      },
      "default": {
        "color": "#ffb4ab"
      },
      "light": {
        "color": "#ba1a1a"
      }
    },
    "error_container": {
      "dark": {
        "color": "#93000a"
      },
      "default": {
        "color": "#93000a"
      },
      "light": {
        "color": "#ffdad6"
      }
    },
    "inverse_on_surface": {
      "dark": {
        "color": "#2c3133"
      },
      "default": {
        "color": "#2c3133"
      },
      "light": {
        "color": "#ecf2f4"
      }
    },
    "inverse_primary": {
      "dark": {
        "color": "#00687b"
      },
      "default": {
        "color": "#00687b"
      },
      "light": {
        "color": "#85d2e8"
      }
    },
    "inverse_surface": {
      "dark": {
        "color": "#dee3e6"
      },
      "default": {
        "color": "#dee3e6"
      },
      "light": {
        "color": "#2c3133"
      }
    },
    "on_background": {
      "dark": {
        "color": "#dee3e6"
      },
      "default": {
        "color": "#dee3e6"
      },
      "light": {
        "color": "#171c1e"
      }
    },
    "on_error": {
      "dark": {
        "color": "#690005"
      },
      "default": {
        "color": "#690005"
      },
      "light": {
        "color": "#ffffff"
      }
    },
    "on_error_container": {
      "dark": {
        "color": "#ffdad6"
      },
      "default": {
        "color": "#ffdad6"
      },
      "light": {
        "color": "#410002"
      }
    },
    "on_primary": {
      "dark": {
        "color": "#003641"
      },
      "default": {
        "color": "#003641"
      },
      "light": {
        "color": "#ffffff"
      }
    },
    "on_primary_container": {
      "dark": {
        "color": "#afecff"
      },
      "default": {
        "color": "#afecff"
      },
      "light": {
        "color": "#001f26"
      }
    },
    "on_primary_fixed": {
      "dark": {
        "color": "#001f26"
      },
      "default": {
        "color": "#001f26"
      },
      "light": {
        "color": "#001f26"
      }
    },
    "on_primary_fixed_variant": {
      "dark": {
        "color": "#004e5d"
      },
      "default": {
        "color": "#004e5d"
      },
      "light": {
        "color": "#004e5d"
      }
    },
    "on_secondary": {
      "dark": {
        "color": "#1d343a"
      },
      "default": {
        "color": "#1d343a"
      },
      "light": {
        "color": "#ffffff"
      }
    },
    "on_secondary_container": {
      "dark": {
        "color": "#cee7ef"
      },
      "default": {
        "color": "#cee7ef"
      },
      "light": {
        "color": "#061f25"
      }
    },
    "on_secondary_fixed": {
      "dark": {
        "color": "#061f25"
      },
      "default": {
        "color": "#061f25"
      },
      "light": {
        "color": "#061f25"
      }
    },
    "on_secondary_fixed_variant": {
      "dark": {
        "color": "#344a51"
      },
      "default": {
        "color": "#344a51"
      },
      "light": {
        "color": "#344a51"
      }
    },
    "on_surface": {
      "dark": {
        "color": "#dee3e6"
      },
      "default": {
        "color": "#dee3e6"
      },
      "light": {
        "color": "#171c1e"
      }
    },
    "on_surface_variant": {
      "dark": {
        "color": "#bfc8cb"
      },
      "default": {
        "color": "#bfc8cb"
      },
      "light": {
        "color": "#3f484b"
      }
    },
    "on_tertiary": {
      "dark": {
        "color": "#292e4d"
      },
      "default": {
        "color": "#292e4d"
      },
      "light": {
        "color": "#ffffff"
      }
    },
    "on_tertiary_container": {
      "dark": {
        "color": "#dee0ff"
      },
      "default": {
        "color": "#dee0ff"
      },
      "light": {
        "color": "#141937"
      }
    },
    "on_tertiary_fixed": {
      "dark": {
        "color": "#141937"
      },
      "default": {
        "color": "#141937"
      },
      "light": {
        "color": "#141937"
      }
    },
    "on_tertiary_fixed_variant": {
      "dark": {
        "color": "#404565"
      },
      "default": {
        "color": "#404565"
      },
      "light": {
        "color": "#404565"
      }
    },
    "outline": {
      "dark": {
        "color": "#899295"
      },
      "default": {
        "color": "#899295"
      },
      "light": {
        "color": "#70787c"
      }
    },
    "outline_variant": {
      "dark": {
        "color": "#3f484b"
      },
      "default": {
        "color": "#3f484b"
      },
      "light": {
        "color": "#bfc8cb"
      }
    },
    "primary": {
      "dark": {
        "color": "#85d2e8"
      },
      "default": {
        "color": "#85d2e8"
      },
      "light": {
        "color": "#00687b"
      }
    },
    "primary_container": {
      "dark": {
        "color": "#004e5d"
      },
      "default": {
        "color": "#004e5d"
      },
      "light": {
        "color": "#afecff"
      }
    },
    "primary_fixed": {
      "dark": {
        "color": "#afecff"
      },
      "default": {
        "color": "#afecff"
      },
      "light": {
        "color": "#afecff"
      }
    },
    "primary_fixed_dim": {
      "dark": {
        "color": "#85d2e8"
      },
      "default": {
        "color": "#85d2e8"
      },
      "light": {
        "color": "#85d2e8"
      }
    },
    "scrim": {
      "dark": {
        "color": "#000000"
      },
      "default": {
        "color": "#000000"
      },
      "light": {
        "color": "#000000"
      }
    },
    "secondary": {
      "dark": {
        "color": "#b2cbd3"
      },
      "default": {
        "color": "#b2cbd3"
      },
      "light": {
        "color": "#4b6269"
      }
    },
    "secondary_container": {
      "dark": {
        "color": "#344a51"
      },
      "default": {
        "color": "#344a51"
      },
      "light": {
        "color": "#cee7ef"
      }
    },
    "secondary_fixed": {
      "dark": {
        "color": "#cee7ef"
      },
      "default": {
        "color": "#cee7ef"
      },
      "light": {
        "color": "#cee7ef"
      }
    },
    "secondary_fixed_dim": {
      "dark": {
        "color": "#b2cbd3"
      },
      "default": {
        "color": "#b2cbd3"
      },
      "light": {
        "color": "#b2cbd3"
      }
    },
    "shadow": {
      "dark": {
        "color": "#000000"
      },
      "default": {
        "color": "#000000"
      },
      "light": {
        "color": "#000000"
      }
    },
    "source_color": {
      "dark": {
        "color": "#30d1f4"
      },
      "default": {
        "color": "#30d1f4"
      },
      "light": {
        "color": "#30d1f4"
      }
    },
    "surface": {
      "dark": {
        "color": "#0f1416"
      },
      "default": {
        "color": "#0f1416"
      },
      "light": {
        "color": "#f5fafc"
      }
    },
    "surface_bright": {
      "dark": {
        "color": "#343a3c"
      },
      "default": {
        "color": "#343a3c"
      },
      "light": {
        "color": "#f5fafc"
      }
    },
    "surface_container": {
      "dark": {
        "color": "#1b2022"
      },
      "default": {
        "color": "#1b2022"
      },
      "light": {
        "color": "#e9eff1"
      }
    },
    "surface_container_high": {
      "dark": {
        "color": "#252b2d"
      },
      "default": {
        "color": "#252b2d"
      },
      "light": {
        "color": "#e4e9eb"
      }
    },
    "surface_container_highest": {
      "dark": {
        "color": "#303638"
      },
      "default": {
        "color": "#303638"
      },
      "light": {
        "color": "#dee3e6"
      }
    },
    "surface_container_low": {
      "dark": {
        "color": "#171c1e"
      },
      "default": {
        "color": "#171c1e"
      },
      "light": {
        "color": "#eff4f7"
      }
    },
    "surface_container_lowest": {
      "dark": {
        "color": "#090f11"
      },
      "default": {
        "color": "#090f11"
      },
      "light": {
        "color": "#ffffff"
      }
    },
    "surface_dim": {
      "dark": {
        "color": "#0f1416"
      },
      "default": {
        "color": "#0f1416"
      },
      "light": {
        "color": "#d5dbdd"
      }
    },
    "surface_tint": {
      "dark": {
        "color": "#85d2e8"
      },
      "default": {
        "color": "#85d2e8"
      },
      "light": {
        "color": "#00687b"
      }
    },
    "surface_variant": {
      "dark": {
        "color": "#3f484b"
      },
      "default": {
        "color": "#3f484b"
      },
      "light": {
        "color": "#dbe4e7"
      }
    },
    "tertiary": {
      "dark": {
        "color": "#c0c4eb"
      },
      "default": {
        "color": "#c0c4eb"
      },
      "light": {
        "color": "#575c7e"
      }
    },
    "tertiary_container": {
      "dark": {
        "color": "#404565"
      },
      "default": {
        "color": "#404565"
      },
      "light": {
        "color": "#dee0ff"
      }
    },
    "tertiary_fixed": {
      "dark": {
        "color": "#dee0ff"
      },
      "default": {
        "color": "#dee0ff"
      },
      "light": {
        "color": "#dee0ff"
      }
    },
    "tertiary_fixed_dim": {
      "dark": {
        "color": "#c0c4eb"
      },
      "default": {
        "color": "#c0c4eb"
      },
      "light": {
        "color": "#c0c4eb"
      }
    }
  },
  "image": "/home/daniel/Pictures/wallpapers/vagabond-water.jpg",
  "is_dark_mode": true,
  "mode": "dark",
  "palettes": {
    "error": {
      "0": {
        "color": "#000000"
      },
      "10": {
        "color": "#410002"
      },
      "100": {
        "color": "#ffffff"
      },
      "15": {
        "color": "#540003"
      },
      "20": {
        "color": "#690005"
      },
      "25": {
        "color": "#7e0007"
      },
      "30": {
        "color": "#93000a"
      },
      "35": {
        "color": "#a80710"
      },
      "40": {
        "color": "#ba1a1a"
      },
      "5": {
        "color": "#2d0001"
      },
      "50": {
        "color": "#de3730"
      },
      "60": {
        "color": "#ff5449"
      },
      "70": {
        "color": "#ff897d"
      },
      "80": {
        "color": "#ffb4ab"
      },
      "90": {
        "color": "#ffdad6"
      },
      "95": {
        "color": "#ffedea"
      },
      "98": {
        "color": "#fff8f7"
      },
      "99": {
        "color": "#fffbff"
      }
    },
    "neutral": {
      "0": {
        "color": "#000000"
      },
      "10": {
        "color": "#191c1d"
      },
      "100": {
        "color": "#ffffff"
      },
      "15": {
        "color": "#232627"
      },
      "20": {
        "color": "#2e3132"
      },
      "25": {
        "color": "#393c3d"
      },
      "30": {
        "color": "#444748"
      },
      "35": {
        "color": "#505354"
      },
      "40": {
        "color": "#5c5f60"
      },
      "5": {
        "color": "#0e1113"
      },
      "50": {
        "color": "#757779"
      },
      "60": {
        "color": "#8e9192"
      },
      "70": {
        "color": "#a9abad"
      },
      "80": {
        "color": "#c5c7c8"
      },
      "90": {
        "color": "#e1e3e4"
      },
      "95": {
        "color": "#eff1f2"
      },
      "98": {
        "color": "#f8f9fb"
      },
      "99": {
        "color": "#fbfcfe"
      }
    },
    "neutral_variant": {
      "0": {
        "color": "#000000"
      },
      "10": {
        "color": "#141d20"
      },
      "100": {
        "color": "#ffffff"
      },
      "15": {
        "color": "#1f272a"
      },
      "20": {
        "color": "#293235"
      },
      "25": {
        "color": "#343d40"
      },
      "30": {
        "color": "#3f484b"
      },
      "35": {
        "color": "#4b5457"
      },
      "40": {
        "color": "#576063"
      },
      "5": {
        "color": "#0a1215"
      },
      "50": {
        "color": "#70787c"
      },
      "60": {
        "color": "#899295"
      },
      "70": {
        "color": "#a4adb0"
      },
      "80": {
        "color": "#bfc8cb"
      },
      "90": {
        "color": "#dbe4e7"
      },
      "95": {
        "color": "#e9f2f6"
      },
      "98": {
        "color": "#f2fbfe"
      },
      "99": {
        "color": "#f8fdff"
      }
    },
    "primary": {
      "0": {
        "color": "#000000"
      },
      "10": {
        "color": "#001f26"
      },
      "100": {
        "color": "#ffffff"
      },
      "15": {
        "color": "#002a33"
      },
      "20": {
        "color": "#003641"
      },
      "25": {
        "color": "#00424f"
      },
      "30": {
        "color": "#004e5d"
      },
      "35": {
        "color": "#005b6c"
      },
      "40": {
        "color": "#00687b"
      },
      "5": {
        "color": "#001419"
      },
      "50": {
        "color": "#00829a"
      },
      "60": {
        "color": "#009ebb"
      },
      "70": {
        "color": "#00bbdc"
      },
      "80": {
        "color": "#3bd7fb"
      },
      "90": {
        "color": "#afecff"
      },
      "95": {
        "color": "#d9f5ff"
      },
      "98": {
        "color": "#f1fbff"
      },
      "99": {
        "color": "#f8fdff"
      }
    },
    "secondary": {
      "0": {
        "color": "#000000"
      },
      "10": {
        "color": "#061f25"
      },
      "100": {
        "color": "#ffffff"
      },
      "15": {
        "color": "#12292f"
      },
      "20": {
        "color": "#1d343a"
      },
      "25": {
        "color": "#283f45"
      },
      "30": {
        "color": "#344a51"
      },
      "35": {
        "color": "#3f565d"
      },
      "40": {
        "color": "#4b6269"
      },
      "5": {
        "color": "#001419"
      },
      "50": {
        "color": "#647b82"
      },
      "60": {
        "color": "#7d959c"
      },
      "70": {
        "color": "#97afb7"
      },
      "80": {
        "color": "#b2cbd3"
      },
      "90": {
        "color": "#cee7ef"
      },
      "95": {
        "color": "#dcf5fd"
      },
      "98": {
        "color": "#f1fbff"
      },
      "99": {
        "color": "#f8fdff"
      }
    },
    "tertiary": {
      "0": {
        "color": "#000000"
      },
      "10": {
        "color": "#141937"
      },
      "100": {
        "color": "#ffffff"
      },
      "15": {
        "color": "#1e2442"
      },
      "20": {
        "color": "#292e4d"
      },
      "25": {
        "color": "#343959"
      },
      "30": {
        "color": "#404565"
      },
      "35": {
        "color": "#4b5071"
      },
      "40": {
        "color": "#575c7e"
      },
      "5": {
        "color": "#090e2c"
      },
      "50": {
        "color": "#707598"
      },
      "60": {
        "color": "#8a8fb3"
      },
      "70": {
        "color": "#a4a9ce"
      },
      "80": {
        "color": "#c0c4eb"
      },
      "90": {
        "color": "#dee0ff"
      },
      "95": {
        "color": "#f0efff"
      },
      "98": {
        "color": "#fbf8ff"
      },
      "99": {
        "color": "#fefbff"
      }
    }
  }
}
```
