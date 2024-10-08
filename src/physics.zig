const std = @import("std");
const rl = @import("raylib");
const hole_module = @import("hole.zig");
const pad_module = @import("pad.zig");

pub fn checkCandyShootigs(hole: hole_module.Hole, pad: pad_module.Pad) void {
    for (pad.shots.items) |*shot| {
        const rectangle = rl.Rectangle.init(shot.pos.x, shot.pos.y, 5.0, 8.0);
        for (hole.candies.items) |*candy| {
            const circle_x = @as(f32, @floatFromInt(candy.center_x));
            const circle_y = @as(f32, @floatFromInt(candy.center_y));
            const center = rl.Vector2.init(circle_x, circle_y);
            const radius = candy.radius;

            if (rl.checkCollisionCircleRec(center, radius, rectangle)) {
                candy.hit();
                shot.hit();
            }
        }
    }
}

pub fn checkHoleShootigs(hole: *hole_module.Hole, pad: pad_module.Pad) void {
    for (pad.shots.items) |*shot| {
        const rectangle = rl.Rectangle.init(shot.pos.x, shot.pos.y, 5.0, 8.0);
        const circle_x = @as(f32, @floatFromInt(hole.center_x));
        const circle_y = @as(f32, @floatFromInt(hole.center_y));
        const center = rl.Vector2.init(circle_x, circle_y);
        const radius = hole.radius;

        if (rl.checkCollisionCircleRec(center, radius, rectangle)) {
            hole.hit();
            shot.hit();
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
