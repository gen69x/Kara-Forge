# Kara-Forge

Automated non-GKI kernel builder for **Xiaomi Redmi 7 / Y3 (onclite)** with **BakaSU + SuSFS**.

Inspired by [zincore-forge](https://github.com/yureixen/zincore-forge).

## Features

- Builds from your own kernel source (`gen69x/Project-KARA` → branch `Kara-BakaSU`)
- Integrates BakaSU (Manual Hook) + SuSFS for kernel 4.9
- Packages with AnyKernel3
- One-click build via GitHub Actions

## How to use

1. Go to **Actions** tab
2. Select **Build Kernel onclite**
3. Click **Run workflow**
4. Download the artifact when finished

## Requirements

- Kernel source already has Manual Hook applied
- AnyKernel3 repo: `gen69x/AnyKernel3`

## Credits

- [Baka-SU](https://github.com/Baka-SU/BakaSU)
- [simonpunk/susfs4ksu](https://gitlab.com/simonpunk/susfs4ksu)
- [yureixen/zincore-forge](https://github.com/yureixen/zincore-forge)
- [kdrag0n/proton-clang](https://github.com/kdrag0n/proton-clang)
