const std = @import("std");

const day01 = @import("day01.zig");
const day02 = @import("day02.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const ally = arena.allocator();

    var args = try std.process.argsWithAllocator(ally);
    defer args.deinit();

    _ = args.skip();
    const day = std.fmt.parseInt(u8, args.next().?, 10) catch @panic("arg must be a day number");

    switch (day) {
        1 => try day01.solve(ally),
        2 => try day02.solve(ally),
        else => @panic("unknown day"),
    }
}

test {
    std.testing.refAllDecls(@This());
}
