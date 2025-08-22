---
created: 2025-08-03T14:22
updated: 2025-08-22T22:10
title:
---
2025-08-21 21:02

Status:

Tags:

# Kitty terminal emulator

* 在arch linux，預設的terminal emulator是konsole，但kitty有較多自定義內容可使用，可依照官網的內容做設定
* 將設定檔放在`~/.config/kitty/kitty.conf` 裡
* My kitty configurations
```conf
# Kitty's font and size
font_family FiraCode Nerd font
font_size 10.0

# BEGIN_KITTY_THEME
# Catppuccin-Mocha
include current-theme.conf
# END_KITTY_THEME
# Transparency

# background_opacity 0.8
# Layout
enabled_layouts tall,*

# Windows
windows_margin 7
windows_border_width 2
single_window_margin 0

# Background
background_image ~/Documents/Wall_paper/images/Wallpaper5.jpg
background_image_layout scaled
background_tint 0.75
background_tint_gaps -10

# TABS
tab_bar_style powerline
tab_powerline_style slanted

# Map keys settings(Additional)
map F1 new_window_with_cwd
map F2 launch --cwd=current /usr/bin/vi

# === 控制分割窗 ===
map ctrl+left neighboring_window left # 切到左邊的分割
map ctrl+right neighboring_window right # 切到右邊的分割
map ctrl+up neighboring_window up # 切到上面的分割
map ctrl+down neighboring_window down # 切到下面的分割

# 重新載入配置
map ctrl+shift+r reload-config

# Close system bell
enable_audio_bell no
```
# Reference
[kitty terminal emulator website](https://sw.kovidgoyal.net/kitty/conf/#the-color-table)
[Setting reference video](https://www.youtube.com/watch?v=U-2AB88_eUw)
