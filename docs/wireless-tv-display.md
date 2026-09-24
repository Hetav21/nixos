# Wireless TV Display Guide (Sunshine + Moonlight + Hyprland)

Guide to using your TV as a wireless, high-refresh extended display from NixOS without requiring proprietary CUDA drivers.

**Source of truth:** [`src/modules/system/media/sunshine.nix`](file:///etc/nixos/src/modules/system/media/sunshine.nix) & [`src/modules/home/desktop/hypr/hyprland.nix`](file:///etc/nixos/src/modules/home/desktop/hypr/hyprland.nix).

---

## 1. Architecture & Why CUDA Is Not Needed

Earlier attempts to stream at 4K/high-refresh assumed NVIDIA CUDA was required for hardware encoding. However:

* **Hardware Video Acceleration:** The 12th Gen Intel Alder Lake integrated GPU (`i915` kernel driver + `iHD` VA-API driver) natively supports hardware HEVC (H.265 Main / Main10 10-bit HDR) and H.264 (AVC) encoding up to 4K and 8K.
* **Compositor Efficiency:** Hyprland renders directly on the Intel iGPU (`/dev/dri/card1` / `/dev/dri/renderD128`). Capturing frames using the Wayland screencopy protocol (`zwlr_screencopy_manager_v1` via DMABUF) occurs directly inside Intel GPU memory.
* **No PCIe Overhead:** Capturing and encoding on the same Intel GPU avoids high-latency cross-adapter PCIe transfers to the discrete NVIDIA card, saving battery and yielding lower latency.
* **No Unfree CUDA Bloat:** Sunshine runs out of the box using upstream NixOS packages (`pkgs.sunshine`) with cached binaries, without requiring gigabytes of unfree CUDA SDK packages or risking driver-version mismatches.

---

## 2. NixOS Configuration Summary

### System Module (`src/modules/system/media/sunshine.nix`)
Enables the Sunshine systemd user daemon (configured with `autoStart = false` so it runs on-demand rather than consuming resources on boot), opens necessary TCP/UDP ports in the firewall, adds `cap_sys_admin` execution capabilities, and grants `uinput` permissions for remote mouse/keyboard/gamepad control:

```nix
system.media.sunshine.enable = true;
```

### Hyprland Virtual Monitor & On-Demand Toggle (`src/modules/home/desktop/hypr/hyprland.nix`)
Configures the geometry for `tv_out` without creating phantom screens on boot:

```ini
monitor = tv_out, 1920x1080@120, auto-right, 1
```

Provides an on-demand toggle helper (`toggle-tv-display`) mapped to the laptop display key and keyboard shortcut:
* **Physical Laptop Key:** `Fn + F9` (`XF86Display`)
* **Keyboard Shortcut:** `Super + Shift + V`
* **CLI:** `toggle-tv-display`

When toggled ON:
* Spawns headless output `tv_out` (Hyprland automatically positions it at `auto-right` at 1080p@120Hz).
* Starts `sunshine.service` via `systemctl --user start sunshine`.
* Emits desktop notification.

When toggled OFF:
* Removes `tv_out` output, shifting active workspaces seamlessly back to `eDP-1`.
* Stops `sunshine.service` via `systemctl --user stop sunshine`.
* Emits desktop notification.

### Sunshine Configuration (`~/.config/sunshine/sunshine.conf`)
Binds Sunshine to hardware VA-API encoding and targets the virtual display:

```ini
encoder = vaapi
output_name = tv_out
```

---

## 3. How to Connect to Your TV

### Step 1: Initialize Admin Credentials (First Time Only)

> [!NOTE]
> Because Sunshine is configured with `autoStart = false` to conserve resources, ensure the service is running before opening the configuration UI: toggle it on via `Fn + F9` (or `Super + Shift + V` / `toggle-tv-display` as described in [Section 6](#6-hyprland-workflow-for-the-tv-display)) or run `systemctl --user start sunshine`.

1. Open a browser on your laptop and go to:
   **[https://localhost:47990](https://localhost:47990)**
2. Accept the self-signed HTTPS certificate warning (click **Advanced** -> **Proceed to localhost**).
3. Set your desired **Username** and **Password** and click **Submit**.
4. *(Alternatively via terminal)*:
   ```bash
   sunshine --creds <username> <password>
   systemctl --user restart sunshine
   ```

### Step 2: Install Moonlight on Your TV

Install the **Moonlight Game Streaming** client on your TV:
* **Android TV / Google TV / Fire TV:** Search for **Moonlight Game Streaming** in the Google Play Store or Amazon Appstore.
* **Apple TV:** Install **Moonlight** from the tvOS App Store.
* **LG webOS:** Install Moonlight via the [webOS Homebrew Channel](https://github.com/mariotaku/moonlight-tv).
* **Samsung Tizen:** Install via [moonlight-chrome-tizen](https://github.com/jeikobu/moonlight-chrome-tizen).

### Step 3: Pair Moonlight with Your PC

1. Ensure your laptop and TV are connected to the same local network (Wi-Fi or Ethernet).
2. Launch Moonlight on your TV. Your PC (`nixbook`) will appear automatically via mDNS/Avahi discovery.
   * *If not detected automatically, select **Add Host Manually** and enter your laptop's IP: `192.168.68.107`.*
3. Select `nixbook`. Moonlight will display a **4-digit PIN** on your TV screen.
4. On your laptop browser, navigate to **[https://localhost:47990/pin](https://localhost:47990/pin)** (or click the **PIN** tab in Sunshine).
5. Enter the PIN and click **Send**. Pairing is complete!
6. Select **Desktop** in Moonlight to begin streaming your extended TV display.

---

## 4. Optimal Settings & Streaming Profiles

Different TV chips and Wi-Fi networks have different strengths. Depending on your use case, configure the following settings in the **Moonlight app on your TV**:

### Profile A: Maximum Fluidity (120 FPS) — *Recommended for High-Refresh*

Best for ultra-smooth mouse cursor motion and 120Hz display panels.

| Setting in Moonlight (TV) | Value | Why |
| :--- | :--- | :--- |
| **Resolution** | **1080p (1920×1080)** | Fits the 8.3ms 120Hz frame window |
| **Frame Rate** | **120 FPS** | Matches Hyprland's 120Hz refresh |
| **Video Codec** | **H.264 (AVC)** | Host encode takes ~6–9 ms (ultra-fast) |
| **Bitrate** | **35 – 45 Mbps** | Prevents Wi-Fi packet drops and jitter |
| **Frame Pacing** | **Balanced** | Syncs frames to TV VSync |

### Profile B: Ultra-Low Latency (~90–94 FPS) — *Recommended for Instant Response*

Best for snappy desktop response with the lowest input lag on MediaTek Smart TV processors.

| Setting in Moonlight (TV) | Value | Why |
| :--- | :--- | :--- |
| **Resolution** | **1080p (1920×1080)** | 1:1 pixel match |
| **Frame Rate** | **90 FPS** or **120 FPS** | Lowers presentation latency |
| **Video Codec** | **HEVC (H.265)** | TV hardware decoder finishes in **7.0 ms**! |
| **Bitrate** | **30 – 40 Mbps** | High compression efficiency |
| **Frame Pacing** | **Balanced** or **Lowest Latency** | Instant responsiveness |

### Profile C: Ultra-HD 4K (60 FPS) — *Recommended for Movies & Crisp Text*

Best for movies, video playback, and reading sharp text across a large 4K TV panel.

| Setting in Moonlight (TV) | Value | Why |
| :--- | :--- | :--- |
| **Resolution** | **4K (3840×2160)** | Native 4K UHD rendering |
| **Frame Rate** | **60 FPS** | Rock-solid 59.85–60.00 FPS |
| **Video Codec** | **HEVC (H.265)** | 10-bit HDR capable, TV decodes in ~13.8 ms |
| **Bitrate** | **40 – 50 Mbps** | Clear image without choking TV Wi-Fi |
| **Frame Pacing** | **Balanced** | Eliminates 62.5 FPS micro-judder |

> [!NOTE]
> If switching to 4K on your TV, switch Hyprland's virtual monitor to 4K dynamically:
> ```bash
> hyprctl keyword monitor "tv_out, 3840x2160@60, auto-right, 1"
> ```

---

## 5. TV Picture & Network Settings (Eliminating Stutter)

If you notice stutter or micro-judder, check these TV settings:

1. **Turn on "Game Mode" or "PC Mode" on the TV:**
   * Modern smart TVs enable motion smoothing ("TruMotion", "Auto Motion Plus", "Motionflow") by default.
   * Motion smoothing buffers frames and causes rhythmic stuttering during interactive PC streaming.
   * Switching your TV picture preset to **Game Mode** or labeling the HDMI/Streaming input as **PC** disables post-processing and drops display lag to minimum.
2. **Frame Pacing Setting in Moonlight:**
   * If you see **62.50 FPS** in Moonlight's overlay while the TV is 60Hz, periodic micro-stutter occurs because 2.5 extra frames arrive every second.
   * In Moonlight Settings -> **Video** -> **Frame Pacing**, set to **Balanced** or **Prefer Smoothest Video**.
3. **Keep Bitrate Reasonable (30–50 Mbps):**
   * Default settings often push 80+ Mbps. Most Smart TV Wi-Fi antennas drop UDP packets at sustained 80 Mbps, triggering recovery frames.
   * HEVC at 35–45 Mbps looks indistinguishable from 80 Mbps while keeping network packet loss at **0.00%**.

---

## 6. Hyprland Workflow for the TV Display

1. **Start Streaming Session:**
   * Press `Fn + F9` (or `Super + Shift + V`, or run `toggle-tv-display` in terminal).
   * A desktop notification will confirm that `tv_out` (1080p@120Hz) is created and Sunshine has started.
2. **Connect via TV:**
   * Launch Moonlight on your TV and select **Desktop**.
3. **Use Extended Display:**
   * **Move mouse:** Move cursor past the right edge of your laptop screen to interact with the TV.
   * **Move windows:** Drag any window to the right onto your TV, or move the active window to the TV workspace using `$mainMod + Shift + <workspace>`.
   * **Dynamic Resolution Toggle:**
     * For 1080p 120Hz: `hyprctl keyword monitor "tv_out, 1920x1080@120, auto-right, 1"`
     * For 4K 60Hz: `hyprctl keyword monitor "tv_out, 3840x2160@60, auto-right, 1"`
4. **End Streaming Session:**
   * Press `Fn + F9` (or `Super + Shift + V`).
   * `tv_out` is immediately removed, workspaces fold cleanly back to your laptop screen, and Sunshine service stops to conserve battery.
