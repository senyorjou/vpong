const std = @import("std");
const rl = @import("raylib");
const settings = @import("settings.zig");
const rnd = @import("randoms.zig");

const MAX_CANDIES = 10;

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
    center_x: i32,
    center_y: i32,
    radius: f32,
    color: rl.Color,
    direction: i32,
    size: f32,
    candies: std.ArrayList(Candy),

    pub fn init(allocator: std.mem.Allocator) Hole {
        return .{ .center_x = 400, .center_y = 100, .radius = 30, .color = rl.Color.blue, .direction = 1, .size = 1.0, .candies = std.ArrayList(Candy).init(allocator) };
    }

    pub fn deinit(self: Hole) void {
        self.candies.deinit();
    }

    pub fn update(self: *Hole) !void {
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

        // Should I drop a candy?
        // if no more than 10 and rnd (0,100) == 13 yessss
        if (self.candies.items.len < MAX_CANDIES and rnd.randomBetween(u8, 0, 100) == 13) {
            try self.candies.append(Candy.init(self));
        }
        // remove dead candies
        for (0.., self.candies.items) |index, candy| {
            if (candy.lives < 1) {
                _ = self.candies.swapRemove(index);
            }
        }
    }

    pub fn draw(self: Hole) void {
        rl.drawCircle(self.center_x, self.center_y, self.radius, self.color);
    }
};

pub const Candy = struct {
    center_x: i32,
    center_y: i32,
    radius: f32 = 10.0,
    direction: Point,
    is_hit: bool = false,
    lives: u8 = 10,

    pub fn init(hole: *Hole) Candy {
        // const x = rnd.randomBetween(i32, 100, 200);
        // const y = rnd.randomBetween(i32, 100, 200);

        const direction: Point = randomDir();

        return Candy{ .center_x = hole.center_x, .center_y = hole.center_y, .direction = direction };
    }

    pub fn hit(self: *Candy) void {
        self.is_hit = true;
    }

    pub fn draw(self: Candy) void {
        const color = if (!self.is_hit) rl.Color.init(40, 230, 255, 220) else rl.Color.init(230, 230, 255, 220);

        rl.drawCircle(self.center_x, self.center_y, self.radius, color);
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
        if (self.is_hit) {
            self.lives -= 1;
        }
    }
};
