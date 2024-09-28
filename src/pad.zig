const std = @import("std");
const settings = @import("settings.zig");
const rl = @import("raylib");

const HORIZONTAL_MOV = 10;
const TAIL_LEN = 10;

pub const Pad = struct {
    pos: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color = rl.Color.white,
    positions: [TAIL_LEN]rl.Vector2,
    pos_index: usize = 0,
    shots: std.ArrayList(Shot) = undefined,

    pub fn init(x: f32, y: f32, w: f32, h: f32, allocator: std.mem.Allocator) Pad {
        const initial_pos = rl.Vector2.init(x, y);
        const positions: [TAIL_LEN]rl.Vector2 = .{initial_pos} ** TAIL_LEN;
        const shots = std.ArrayList(Shot).init(allocator);
        return .{ .pos = initial_pos, .size = rl.Vector2.init(w, h), .positions = positions, .shots = shots };
    }

    pub fn deinit(self: Pad) void {
        self.shots.deinit();
    }

    fn update_position_history(self: *Pad) void {
        var i: usize = 0;
        while (i < TAIL_LEN - 1) : (i += 1) {
            self.positions[i] = self.positions[i + 1];
        }
        self.positions[TAIL_LEN - 1] = self.pos;
    }

    pub fn update(self: *Pad, accel: bool) !void {
        const mov: f32 = if (accel) HORIZONTAL_MOV * 2 else HORIZONTAL_MOV;

        if (rl.isKeyDown(rl.KeyboardKey.key_a)) {
            if (self.pos.x > settings.LEFT_WALL) {
                self.pos.x -= mov;
            }
        }
        if (rl.isKeyDown(rl.KeyboardKey.key_d)) {
            if (self.pos.x < settings.window.width - self.size.x - HORIZONTAL_MOV) {
                self.pos.x += mov;
            }
        }

        if (rl.isKeyReleased(rl.KeyboardKey.key_space)) {
            try self.shots.append(Shot.init(self.pos));
        }

        for (0.., self.shots.items) |index, *shot| {
            if (shot.pos.y < settings.TOP_WALL) {
                _ = self.shots.swapRemove(index);
            } else {
                shot.update();
            }
        }
    }

    pub fn draw(self: *Pad) void {
        // first draw the tail in reverse, only tail-length -2
        var tail_index: u8 = TAIL_LEN - 1;
        var alpha: u8 = 255;
        while (tail_index != 0) : (tail_index -= 1) {
            alpha /= 2;
            const current_color = rl.Color{
                .r = 242,
                .g = 234,
                .b = 142,
                .a = alpha,
            };
            rl.drawRectangleV(self.positions[tail_index], self.size, current_color);
        }
        rl.drawRectangleV(self.pos, self.size, self.color);

        self.update_position_history();

        for (self.shots.items) |*shot| {
            shot.draw();
        }
    }
};

pub const Shot = struct {
    pos: rl.Vector2,

    pub fn init(pos: rl.Vector2) Shot {
        const x = pos.x + 27.0;
        const y = pos.y - 20.0;

        return .{ .pos = rl.Vector2.init(x, y) };
    }

    pub fn draw(self: *Shot) void {
        const size = rl.Vector2.init(5.0, 8.0);
        var color = rl.Color.init(255, 60, 60, 255);
        rl.drawRectangleV(self.pos, size, color);

        var pos = self.pos.add(rl.Vector2.init(0.0, 10.0));
        color = rl.Color.init(255, 20, 20, 200);
        rl.drawRectangleV(pos, size, color);

        pos = self.pos.add(rl.Vector2.init(0.0, 20.0));
        color = rl.Color.init(255, 20, 20, 150);
        rl.drawRectangleV(pos, size, color);
    }

    pub fn update(self: *Shot) void {
        self.pos.y -= 8;
    }
};
