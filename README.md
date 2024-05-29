<div align="center">
  <video controls> 
    <source src=".github/res/dvd_video.mov" type="video/mov">
  A short video showcase of raylib-dvd in action
  </video>
</div>

# Raylib DVD
A simple recreation of the iconic 'dvd bouncing' logo

## Compile
1. Make sure you have [zig 0.12](https://ziglang.org/download/) installed!
2. To build...
   - an executable do `zig build`
   - a web export do `zig build -Dtarget=wasm32-emscripten --sysroot [path to emsdk]/upstream/emscripten`
3. Stare away while the dvd logo slowly rots your brain
