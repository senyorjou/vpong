const std = @import("std");
const rl = @import("raylib");

pub const Shot = struct {
    x: i32,
    y: i32,

    pub fn update(self: *Shot) void {
        if (rl.isKeyReleased(rl.KeyboardKey.key_space)) {
            std.debug.print("SPACE! {any}", .{self.x});
        }
    }
};
