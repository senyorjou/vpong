const std = @import("std");
const rl = @import("raylib");
const settings = @import("settings.zig");

pub fn drawHeader(font: rl.Font) void {
    const position = rl.Vector2{ .x = 10.0, .y = 10.0 };
    const font_size = 48.0;
    const spacing = 2.0;
    rl.drawTextEx(font, "Moar VPONG", position, font_size, spacing, settings.color_4);
}

pub fn drawArena() void {
    rl.drawRectangleLines(10, 60, 780, 530, rl.Color.yellow);
}

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
