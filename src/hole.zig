const rl = @import("raylib");
const settings = @import("settings.zig");

pub const Hole = struct {
    center_x: i32 = 400,
    center_y: i32 = 100,
    radius: f32 = 30.0,
    color: rl.Color = rl.Color.green,
    direction: i32 = 1, // right
    size: f32 = 1.0,
    // positions: [TAIL_LEN]rl.Vector2,
    // pos_index: usize = 0,

    pub fn update(self: *Hole) void {
        if (self.radius > 30.0 or self.radius < 10.0) {
            self.size *= -1.0;
        }
        self.radius += self.size;

        if (self.direction == 1) {
            if (self.center_x > (settings.window.width - @as(i32, @intFromFloat(self.radius)) - 10)) {
                self.direction = -1;
            }
        } else {
            if (self.center_x < (settings.LEFT_WALL + @as(i32, @intFromFloat(self.radius)))) {
                self.direction = 1;
            }
        }
        self.center_x += (6 * self.direction);
    }

    pub fn draw(self: Hole) void {
        rl.drawCircle(self.center_x, self.center_y, self.radius, rl.Color.blue);
    }
};

pub const Ball = struct {
    center_x: i32,
    center_y: i32,
    radius: f32,
    color: rl.Color,
    direction: rl.Vector2,
    speed: f32,
};
