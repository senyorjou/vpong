const std = @import("std");
const rl = @import("raylib");

const settings = @import("settings.zig");
const els = @import("elements.zig");
const hole_module = @import("hole.zig");

fn randomInRange(comptime T: type, min: T, max: T) T {
    const random = std.crypto.random.int(T);
    const range = max - min + 1;
    return @rem(random + range, range) + min;
}

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------

    rl.initWindow(settings.window.width, settings.window.height, "Vprong");
    defer rl.closeWindow(); // Close window and OpenGL context

    const font = rl.loadFontEx("./resources/Atop-R99O3.ttf", 48, null);
    std.debug.print("FONT INFO: {}", .{font});
    defer rl.unloadFont(font);

    // elements
    var pad = els.Pad.init((settings.window.width / 2) - (60 / 2), settings.window.height - 40, 60, 20);
    var hole = hole_module.Hole{};
    var accel = els.Accel{};
    var random_int: i32 = randomInRange(i32, 1, 10);

    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update

        // Draw
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(settings.color_3);

        // update everything
        pad.update(accel.is_active);
        hole.update();
        accel.update();

        // draw
        pad.draw();
        hole.draw();
        accel.draw();
        els.drawHeader(font);
        std.debug.print("Random {d}\t\t", .{random_int});
        random_int = randomInRange(i32, 1, 10);
    }
}
