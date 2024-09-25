const rl = @import("raylib");
const settings = @import("settings.zig");
const rnd = @import("randoms.zig");

const Point = struct {
    x: i32,
    y: i32,
};

fn randomDir() Point {
    const x = rnd.randomBetween(i32, -5, 5);
    const y = rnd.randomBetween(i32, 1, 10);

    return Point{ .x = x, .y = y };
}

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

pub const Candy = struct {
    center_x: i32,
    center_y: i32,
    radius: f32 = 10.0,
    direction: Point,

    pub fn init(hole: Hole) Candy {
        // const x = rnd.randomBetween(i32, 100, 200);
        // const y = rnd.randomBetween(i32, 100, 200);

        const direction: Point = randomDir();

        return Candy{ .center_x = hole.center_x, .center_y = hole.center_y, .direction = direction };
    }

    pub fn draw(self: Candy) void {
        rl.drawCircle(self.center_x, self.center_y, self.radius, rl.Color.blue);
    }

    pub fn update(self: *Candy) void {
        const int_radius = @as(i32, @intFromFloat(self.radius));
        self.center_x += self.direction.x;
        self.center_y += self.direction.y;

        if (self.center_x > (settings.RIGHT_WALL - int_radius + 10)) {
            self.direction.x *= -1;
        }

        if (self.center_x < (settings.LEFT_WALL - int_radius + 20)) {
            self.direction.x *= -1;
        }

        if (self.center_y < (settings.TOP_WALL - int_radius + 20)) {
            self.direction.y *= -1;
        }

        if (self.center_y > (settings.window.height - int_radius - 10)) {
            self.direction.y *= -1;
        }
    }
};
