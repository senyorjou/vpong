const std = @import("std");
const rl = @import("raylib");

const settings = @import("settings.zig");
const els = @import("elements.zig");
const hole_module = @import("hole.zig");
const pad_module = @import("pad.zig");
const rnd = @import("randoms.zig");

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

    // balls

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // candies
    var candies = std.ArrayList(hole_module.Candy).init(allocator);
    defer candies.deinit();

    // bullets
    var shots = std.ArrayList(pad_module.Shot).init(allocator);
    defer shots.deinit();

    //
    rl.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update conditions
        // Should I drop a candy?
        // if rnd (0,100) == 13 yessss
        //
        if (rnd.randomBetween(u8, 0, 100) == 13) {
            try candies.append(hole_module.Candy.init(hole));
        }

        // Draw
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(settings.color_3);

        // update everything
        pad.update(accel.is_active);
        hole.update();
        accel.update();

        for (candies.items) |*candy| {
            candy.update();
        }

        for (shots.items) |*shot| {
            shot.update();
        }

        // draw
        els.drawHeader(font);
        els.drawArena();
        pad.draw();
        hole.draw();
        accel.draw();

        for (candies.items) |*candy| {
            candy.draw();
        }
    }
}
