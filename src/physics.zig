const std = @import("std");
const rl = @import("raylib");
const hole_module = @import("hole.zig");
const pad_module = @import("pad.zig");

pub fn checkShootigs(hole: hole_module.Hole, pad: pad_module.Pad) void {
    for (pad.shots.items) |*shot| {
        const rectangle = rl.Rectangle.init(shot.pos.x, shot.pos.y, 5.0, 8.0);
        for (hole.candies.items) |*candy| {
            const circle_x = @as(f32, @floatFromInt(candy.center_x));
            const circle_y = @as(f32, @floatFromInt(candy.center_y));
            const center = rl.Vector2.init(circle_x, circle_y);
            const radius = candy.radius;

            if (rl.checkCollisionCircleRec(center, radius, rectangle)) {
                candy.hit();
            }
        }
    }
}

pub fn checkCrash(hole: hole_module.Hole, pad: *pad_module.Pad) void {
    const rectangle = rl.Rectangle.init(pad.pos.x, pad.pos.y, pad.size.x, pad.size.y);
    for (hole.candies.items) |*candy| {
        const circle_x = @as(f32, @floatFromInt(candy.center_x));
        const circle_y = @as(f32, @floatFromInt(candy.center_y));
        const center = rl.Vector2.init(circle_x, circle_y);
        const radius = candy.radius;

        if (rl.checkCollisionCircleRec(center, radius, rectangle)) {
            pad.hit();
            candy.hit();
        }
    }
}

// Check collision between circle and rectangle
pub fn checkCollisionCircleRec(center: rl.Vector2, radius: f32, rec: rl.Rectangle) bool {
    _ = center; // autofix
    _ = radius; // autofix
    _ = rec; // autofix
    // return cdef.CheckCollisionCircleRec(center, radius, rec);
    return false;
}
//
//
// pub const Rectangle = extern struct {
//     x: f32,
//     y: f32,
//     width: f32,
//     height: f32,
