const std = @import("std");
const rl = @import("raylib");

const settings = @import("settings.zig");
const els = @import("elements.zig");
const hole_module = @import("hole.zig");
const pad_module = @import("pad.zig");
const rnd = @import("randoms.zig");
const phys = @import("physics.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    rl.initWindow(settings.window.width, settings.window.height, "Vprong");
    defer rl.closeWindow(); // Close window and OpenGL context

    const font = rl.loadFontEx("./resources/Atop-R99O3.ttf", 48, null);
    std.debug.print("FONT INFO: {}", .{font});
    defer rl.unloadFont(font);

    // elements
    var pad = pad_module.Pad.init((settings.window.width / 2) - (60 / 2), settings.window.height - 40, 60, 20, allocator);
    defer pad.deinit();

    var hole = hole_module.Hole.init(allocator);
    defer hole.deinit();

    var accel = els.Accel{};

    //
    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update conditions

        // Draw
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(settings.color_3);

        if (pad.is_hit or hole.is_dead) {
            els.drawHeader(font);
            els.drawArena();
            hole.draw();
            accel.draw();
            pad.draw();

            for (hole.candies.items) |*candy| {
                candy.draw();
            }
        } else {
            // update everything
            try pad.update(accel.is_active);
            try hole.update();
            accel.update();

            for (hole.candies.items) |*candy| {
                candy.update();
            }

            // draw
            els.drawHeader(font);
            els.drawArena();
            pad.draw();
            hole.draw();
            accel.draw();

            for (hole.candies.items) |*candy| {
                candy.draw();
            }

            // check collisions
            // check if bullets have impacted
            phys.checkCandyShootigs(hole, pad);
            phys.checkHoleShootigs(&hole, pad);
            phys.checkCrash(hole, &pad);
        }
    }
}
