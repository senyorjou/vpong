const std = @import("std");
const rl = @import("raylib");
const settings = @import("settings.zig");

pub fn drawHeader(font: rl.Font) void {
    const position = rl.Vector2{ .x = 10.0, .y = 10.0 };
    const font_size = 48.0;
    const spacing = 2.0;
    rl.drawTextEx(font, "Moar VPONG", position, font_size, spacing, settings.color_4);
}

const HORIZONTAL_MOV = 10;
const TAIL_LEN = 10;

pub const Accel = struct {
    is_active: bool = false,
    meter: u8 = 100,
    is_reloading: bool = false,

    pub fn update(self: *Accel) void {
        // energy only depletes when pad is moving
        if (rl.isKeyDown(rl.KeyboardKey.key_right_shift) and
            !self.is_reloading and
            (rl.isKeyDown(rl.KeyboardKey.key_a) or rl.isKeyDown(rl.KeyboardKey.key_d)))
        {
            self.is_active = true;
            self.meter -= if (self.meter > 0) 1 else 0;
        } else {
            self.is_active = false;
            self.meter += if (self.meter < 100) 1 else 0;
        }
        // switch points
        if (self.meter == 0) {
            self.is_reloading = true;
        } else if (self.meter == 100) {
            self.is_reloading = false;
        }
    }

    pub fn draw(self: Accel) void {
        const meterWidth: i32 = self.meter;
        const meterHeight: i32 = 20;
        const color = if (self.is_reloading) rl.Color.orange else rl.Color.green;

        rl.drawRectangle(690, 20, meterWidth, meterHeight, color);
    }
};

pub const Pad = struct {
    pos: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color = rl.Color.white,
    positions: [TAIL_LEN]rl.Vector2,
    pos_index: usize = 0,

    pub fn init(x: f32, y: f32, w: f32, h: f32) Pad {
        const initial_pos = rl.Vector2.init(x, y);
        const positions: [TAIL_LEN]rl.Vector2 = .{initial_pos} ** TAIL_LEN;
        return .{ .pos = initial_pos, .size = rl.Vector2.init(w, h), .positions = positions };
    }

    fn update_position_history(self: *Pad) void {
        var i: usize = 0;
        while (i < TAIL_LEN - 1) : (i += 1) {
            self.positions[i] = self.positions[i + 1];
        }
        self.positions[TAIL_LEN - 1] = self.pos;
    }

    pub fn update(self: *Pad, accel: bool) void {
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
    }

    // pub fn left(self: *Pad, accel: bool) void {
    //     const mov: f32 = if (accel) HORIZONTAL_MOV * 2 else HORIZONTAL_MOV;
    //     if (self.pos.x > settings.LEFT_WALL) {
    //         self.pos.x -= mov;
    //     }
    // }
    //
    // pub fn right(self: *Pad, accel: bool) void {
    //     const mov: f32 = if (accel) HORIZONTAL_MOV * 2 else HORIZONTAL_MOV;
    //     if (self.pos.x < settings.window.width - self.size.x - HORIZONTAL_MOV) {
    //         self.pos.x += mov;
    //     }
    // }

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
    }
};
