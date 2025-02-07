const std = @import("std");
const t = std.text.Tokenizer;
const input_test = @embedFile("data/day03-test.txt");
const input = @embedFile("data/day03.txt");

const MulParser = struct {
    input: []const u8,
    pos: usize = 0,

    pub fn next(_: *MulParser) !u32 {}
};

fn solution1(allocator: std.mem.Allocator, data: []const u8) !u32 {
    _ = allocator; // autofix
    _ = data;
    return 0;
}

pub fn solve(allocator: std.mem.Allocator) !void {
    std.debug.print("solution 1: {d}\n", .{try solution1(allocator, input)});
    // std.debug.print("solution 2: {d}\n", .{try solution2(allocator, input)});
}
