const std = @import("std");

pub fn randomBetween(comptime T: type, min: T, max: T) T {
    const random = std.crypto.random.int(T);
    const div = max + 1 - min;

    return @mod(random, div) + min;
}
