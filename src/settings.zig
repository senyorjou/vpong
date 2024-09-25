const rl = @import("raylib");

const Window = struct {
    width: i32 = 800,
    height: i32 = 600,
};

pub const window = Window{};

pub const color_1 = rl.Color.init(91, 35, 51, 255);
pub const color_2 = rl.Color.init(247, 244, 243, 255);
pub const color_3 = rl.Color.init(86, 77, 74, 255);
pub const color_4 = rl.Color.init(242, 67, 51, 255);
pub const color_5 = rl.Color.init(186, 27, 29, 255);

pub const LEFT_WALL = 10;
pub const RIGHT_WALL = window.width - LEFT_WALL - 10;
pub const TOP_WALL = 60;
