const std = @import("std");
const input_test = @embedFile("data/day01-test.txt");
const input = @embedFile("data/day01.txt");

fn read_input(allocator: std.mem.Allocator, input_text: []const u8) ![2][]i32 {
    var list1 = std.ArrayList(i32).init(allocator);
    defer list1.deinit();
    var list2 = std.ArrayList(i32).init(allocator);
    defer list2.deinit();

    var lines = std.mem.tokenizeAny(u8, input_text, "\r\n");

    while (lines.next()) |line| {
        var nums = std.mem.tokenizeAny(u8, line, "\t ");
        try list1.append(std.fmt.parseInt(i32, nums.next().?, 10) catch unreachable);
        try list2.append(std.fmt.parseInt(i32, nums.next().?, 10) catch unreachable);
    }

    return [2][]i32{ try list1.toOwnedSlice(), try list2.toOwnedSlice() };
}

fn solution1(allocator: std.mem.Allocator, input_text: []const u8) !u32 {
    const lists = try read_input(allocator, input_text);
    defer allocator.free(lists[0]);
    defer allocator.free(lists[1]);

    std.mem.sort(i32, lists[0], {}, std.sort.asc(i32));
    std.mem.sort(i32, lists[1], {}, std.sort.asc(i32));

    var result: u32 = 0;
    for (lists[0], lists[1]) |n1, n2| {
        result += @abs(n1 - n2);
    }

    return result;
}

pub fn solve(allocator: std.mem.Allocator) !void {
    std.debug.print("solution 1: {d}\n", .{try solution1(allocator, input)});
}

test {
    try std.testing.expectEqual(11, try solution1(std.testing.allocator, input_test));
}