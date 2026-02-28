#!/usr/bin/env python3
"""Generate App Store screenshots for AI News Today."""

from PIL import Image, ImageDraw, ImageFont
import os

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "generated")

DEVICE_SIZES = {
    "iPhone_6.7": (1290, 2796),
    "iPhone_6.5": (1284, 2778),
    "iPhone_5.5": (1242, 2208),
    "iPad_12.9":  (2048, 2732),
}

SCREENS = [
    {"caption": "AI-Powered\nNews Digest", "subtitle": "Stay informed with curated stories", "bg_top": (15, 23, 42), "bg_bottom": (30, 58, 138), "mock": "feed"},
    {"caption": "Personalized\nFor You", "subtitle": "Topics tailored to your interests", "bg_top": (88, 28, 135), "bg_bottom": (187, 55, 142), "mock": "topics"},
    {"caption": "Save Articles\nFor Later", "subtitle": "Bookmark what matters most", "bg_top": (7, 89, 133), "bg_bottom": (20, 170, 170), "mock": "bookmarks"},
    {"caption": "Daily Digest\nNotifications", "subtitle": "Never miss a story", "bg_top": (180, 83, 9), "bg_bottom": (234, 138, 30), "mock": "notifications"},
    {"caption": "Smart\nSummaries", "subtitle": "Get the key points in seconds", "bg_top": (21, 94, 59), "bg_bottom": (52, 168, 83), "mock": "summary"},
]

def draw_rounded_rect(draw, xy, radius, fill):
    draw.rounded_rectangle(xy, radius=radius, fill=fill)

def draw_phone_mockup(draw, w, h, mock_type, is_ipad=False):
    if is_ipad:
        frame_w, frame_h = int(w * 0.75), int(h * 0.52)
    else:
        frame_w, frame_h = int(w * 0.65), int(h * 0.55)
    frame_x = (w - frame_w) // 2
    frame_y = h - frame_h - int(h * 0.06)
    border = int(frame_w * 0.03)
    draw_rounded_rect(draw, (frame_x, frame_y, frame_x + frame_w, frame_y + frame_h), radius=int(frame_w * 0.08), fill=(20, 20, 25))
    sx, sy = frame_x + border, frame_y + border
    sw, sh = frame_w - 2 * border, frame_h - 2 * border
    sr = int(frame_w * 0.06)
    draw_rounded_rect(draw, (sx, sy, sx + sw, sy + sh), radius=sr, fill=(28, 28, 35))
    bar_h = int(sh * 0.04)
    draw_rounded_rect(draw, (sx, sy, sx + sw, sy + bar_h + sr), radius=sr, fill=(35, 35, 45))
    cy = sy + bar_h + int(sh * 0.02)
    cx = sx + int(sw * 0.05)
    cw = int(sw * 0.9)

    if mock_type == "feed":
        for i in range(4):
            card_y = cy + int(sh * 0.06) + i * int(sh * 0.2)
            card_h = int(sh * 0.17)
            if card_y + card_h > sy + sh - border: break
            draw_rounded_rect(draw, (cx, card_y, cx + cw, card_y + card_h), radius=int(sw * 0.03), fill=(45, 45, 58))
            ts = int(card_h * 0.7)
            tx = cx + int(cw * 0.03)
            tty = card_y + (card_h - ts) // 2
            colors = [(59,130,246),(168,85,247),(236,72,153),(34,197,94)]
            draw_rounded_rect(draw, (tx, tty, tx + ts, tty + ts), radius=int(sw * 0.02), fill=colors[i % 4])
            ttx = tx + ts + int(cw * 0.04)
            lh = int(card_h * 0.08)
            for j in range(3):
                ly = card_y + int(card_h * 0.2) + j * int(lh * 2.2)
                lw = cw - ts - int(cw * 0.14)
                if j == 2: lw = int(lw * 0.6)
                draw_rounded_rect(draw, (ttx, ly, ttx + lw, ly + lh), radius=lh // 2, fill=(80, 80, 100))

    elif mock_type == "topics":
        chip_colors = [(59,130,246),(168,85,247),(236,72,153),(234,138,30),(34,197,94),(239,68,68),(20,184,166),(99,102,241),(245,158,11)]
        ch_h = int(sh * 0.055)
        ch_y = cy + int(sh * 0.08)
        ch_x = cx
        for i, color in enumerate(chip_colors):
            ch_w = int(cw * (0.28 + (i % 3) * 0.05))
            if ch_x + ch_w > cx + cw:
                ch_x = cx
                ch_y += int(ch_h * 1.6)
            if ch_y + ch_h > sy + sh - border: break
            draw_rounded_rect(draw, (ch_x, ch_y, ch_x + ch_w, ch_y + ch_h), radius=ch_h // 2, fill=color)
            if i < 3:
                mr = int(ch_h * 0.2)
                mmx = ch_x + ch_w - int(ch_h * 0.5)
                mmy = ch_y + ch_h // 2
                draw.ellipse((mmx - mr, mmy - mr, mmx + mr, mmy + mr), fill=(255, 255, 255))
            ch_x += ch_w + int(cw * 0.03)

    elif mock_type == "bookmarks":
        for i in range(3):
            card_y = cy + int(sh * 0.06) + i * int(sh * 0.22)
            card_h = int(sh * 0.18)
            if card_y + card_h > sy + sh - border: break
            draw_rounded_rect(draw, (cx, card_y, cx + cw, card_y + card_h), radius=int(sw * 0.03), fill=(45, 45, 58))
            bx = cx + cw - int(cw * 0.1)
            by = card_y + int(card_h * 0.15)
            bs = int(card_h * 0.2)
            draw_rounded_rect(draw, (bx, by, bx + bs, by + int(bs * 1.3)), radius=3, fill=(59, 130, 246))
            for j in range(3):
                ly = card_y + int(card_h * 0.2) + j * int(card_h * 0.2)
                lw = int(cw * (0.7 if j < 2 else 0.4))
                lh = int(card_h * 0.08)
                draw_rounded_rect(draw, (cx + int(cw * 0.05), ly, cx + int(cw * 0.05) + lw, ly + lh), radius=lh // 2, fill=(80, 80, 100))

    elif mock_type == "notifications":
        card_y = cy + int(sh * 0.15)
        card_h = int(sh * 0.2)
        draw_rounded_rect(draw, (cx, card_y, cx + cw, card_y + card_h), radius=int(sw * 0.04), fill=(55, 55, 70))
        br = int(card_h * 0.2)
        bcx = cx + int(cw * 0.12)
        bcy = card_y + card_h // 2
        draw.ellipse((bcx - br, bcy - br, bcx + br, bcy + br), fill=(234, 138, 30))
        for j in range(2):
            ly = card_y + int(card_h * 0.3) + j * int(card_h * 0.22)
            lw = int(cw * (0.55 if j == 0 else 0.35))
            lh = int(card_h * 0.1)
            draw_rounded_rect(draw, (bcx + br + int(cw * 0.05), ly, bcx + br + int(cw * 0.05) + lw, ly + lh), radius=lh // 2, fill=(90, 90, 110))
        tw, th = int(cw * 0.35), int(sh * 0.06)
        tty = card_y + card_h + int(sh * 0.06)
        ttx = (w - tw) // 2
        draw_rounded_rect(draw, (ttx, tty, ttx + tw, tty + th), radius=th // 2, fill=(34, 197, 94))
        kr = int(th * 0.4)
        kx = ttx + tw - int(th * 0.55)
        ky = tty + th // 2
        draw.ellipse((kx - kr, ky - kr, kx + kr, ky + kr), fill=(255, 255, 255))

    elif mock_type == "summary":
        card_y = cy + int(sh * 0.06)
        card_h = int(sh * 0.45)
        draw_rounded_rect(draw, (cx, card_y, cx + cw, card_y + card_h), radius=int(sw * 0.03), fill=(45, 45, 58))
        hh = int(card_h * 0.12)
        draw_rounded_rect(draw, (cx, card_y, cx + cw, card_y + hh + int(sw * 0.03)), radius=int(sw * 0.03), fill=(59, 130, 246))
        for j in range(5):
            dy = card_y + hh + int(card_h * 0.08) + j * int(card_h * 0.14)
            dr = int(card_h * 0.015)
            dcx = cx + int(cw * 0.08)
            if dy + dr * 2 > card_y + card_h - int(card_h * 0.05): break
            draw.ellipse((dcx - dr, dy - dr, dcx + dr, dy + dr), fill=(120, 120, 150))
            lw = int(cw * (0.7 if j % 2 == 0 else 0.55))
            lh = int(card_h * 0.04)
            draw_rounded_rect(draw, (dcx + dr * 3, dy - lh // 2, dcx + dr * 3 + lw, dy + lh // 2), radius=lh // 2, fill=(80, 80, 100))

    # Tab bar
    tab_h = int(sh * 0.07)
    tab_y = sy + sh - tab_h
    draw_rounded_rect(draw, (sx, tab_y - sr, sx + sw, sy + sh), radius=sr, fill=(30, 30, 40))
    draw.rectangle((sx, tab_y, sx + sw, tab_y + 1), fill=(50, 50, 65))
    for i in range(3):
        dx = sx + int(sw * (0.2 + i * 0.3))
        dy = tab_y + tab_h // 2
        dr = int(tab_h * 0.12)
        color = (59, 130, 246) if i == 0 else (80, 80, 100)
        draw.ellipse((dx - dr, dy - dr, dx + dr, dy + dr), fill=color)

def create_gradient(w, h, top, bottom):
    img = Image.new("RGB", (w, h))
    px = img.load()
    for y in range(h):
        r = y / h
        c = tuple(int(top[i] + (bottom[i] - top[i]) * r) for i in range(3))
        for x in range(w):
            px[x, y] = c
    return img

def get_font(size, bold=False):
    paths = [
        "/System/Library/Fonts/SFNS.ttf",
        "/Library/Fonts/SF-Pro-Display-Bold.otf" if bold else "/Library/Fonts/SF-Pro-Display-Regular.otf",
        "/System/Library/Fonts/Helvetica.ttc",
    ]
    for p in paths:
        if os.path.exists(p):
            try: return ImageFont.truetype(p, size)
            except: continue
    return ImageFont.load_default()

def generate_screenshot(screen, device_name, size):
    w, h = size
    is_ipad = "iPad" in device_name
    img = create_gradient(w, h, screen["bg_top"], screen["bg_bottom"])
    draw = ImageDraw.Draw(img)
    cs = int(h * 0.055) if not is_ipad else int(h * 0.05)
    ss = int(h * 0.022) if not is_ipad else int(h * 0.02)
    cf = get_font(cs, bold=True)
    sf = get_font(ss)
    caption_y = int(h * 0.06)
    for i, line in enumerate(screen["caption"].split("\n")):
        bbox = draw.textbbox((0, 0), line, font=cf)
        tw = bbox[2] - bbox[0]
        tx = (w - tw) // 2
        ty = caption_y + i * int(cs * 1.25)
        draw.text((tx + 2, ty + 2), line, font=cf, fill=(0, 0, 0))
        draw.text((tx, ty), line, font=cf, fill=(255, 255, 255))
    sub_y = caption_y + len(screen["caption"].split("\n")) * int(cs * 1.25) + int(h * 0.02)
    bbox = draw.textbbox((0, 0), screen["subtitle"], font=sf)
    tw = bbox[2] - bbox[0]
    draw.text(((w - tw) // 2, sub_y), screen["subtitle"], font=sf, fill=(220, 220, 240))
    draw_phone_mockup(draw, w, h, screen["mock"], is_ipad=is_ipad)
    return img

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    for dn, size in DEVICE_SIZES.items():
        dd = os.path.join(OUTPUT_DIR, dn)
        os.makedirs(dd, exist_ok=True)
        for i, screen in enumerate(SCREENS):
            img = generate_screenshot(screen, dn, size)
            fn = f"{i+1:02d}_{screen['mock']}.png"
            fp = os.path.join(dd, fn)
            img.save(fp, "PNG")
            print(f"  ✓ {dn}/{fn} ({size[0]}x{size[1]})")
    print(f"\nDone! Generated {len(SCREENS) * len(DEVICE_SIZES)} screenshots in {OUTPUT_DIR}")

if __name__ == "__main__":
    main()
