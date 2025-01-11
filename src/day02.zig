const std = @import("std");
const input_test = @embedFile("data/day02-test.txt");
const input = @embedFile("data/day02.txt");

fn read_input(allocator: std.mem.Allocator, input_text: []const u8) ![][]const i32 {
    var list = std.ArrayList([]const i32).init(allocator);
    defer list.deinit();

    var lines = std.mem.tokenizeAny(u8, input_text, "\r\n");

    while (lines.next()) |line| {
        var report = std.ArrayList(i32).init(allocator);
        defer report.deinit();

        var nums = std.mem.tokenizeAny(u8, line, "\t ");
        while (nums.next()) |n| {
            try report.append(std.fmt.parseInt(i32, n, 10) catch unreachable);
        }

        try list.append(try report.toOwnedSlice());
    }

    return list.toOwnedSlice();
}

fn is_safe_with_ignore(reports: []const i32, ignore_idx: ?usize) bool {
    var dir: ?bool = null;

    for (reports[0 .. reports.len - 1], 0..) |cur, i| {
        if (i == ignore_idx) continue;
        if (i + 1 == ignore_idx and i + 2 >= reports.len) return true;
        const next = if (i + 1 == ignore_idx) reports[i + 2] else reports[i + 1];
        if (cur == next) return false;
        if (@abs(cur - next) > 3) return false;
        if (dir == null) dir = cur < next;
        if ((cur < next and !dir.?) or (cur > next and dir.?)) return false;
    }

    return true;
}

fn is_safe(reports: []const i32) bool {
    return is_safe_with_ignore(reports, null);
}

fn is_safe2(reports: []const i32) bool {
    if (is_safe(reports)) return true;
    for (0..reports.len) |i| {
        if (is_safe_with_ignore(reports, i)) {
            return true;
        }
    }
    return false;
}

fn solution1(allocator: std.mem.Allocator, input_text: []const u8) !i32 {
    const reports = try read_input(allocator, input_text);
    defer {
        for (reports) |r| allocator.free(r);
        allocator.free(reports);
    }

    var result: i32 = 0;
    for (reports) |r| {
        if (is_safe(r)) result += 1;
    }
    return result;
}

fn solution2(allocator: std.mem.Allocator, input_text: []const u8) !i32 {
    const reports = try read_input(allocator, input_text);
    defer {
        for (reports) |r| allocator.free(r);
        allocator.free(reports);
    }

    var result: i32 = 0;
    for (reports) |r| {
        if (is_safe2(r)) result += 1;
    }
    return result;
}

pub fn solve(allocator: std.mem.Allocator) !void {
    std.debug.print("solution 1: {d}\n", .{try solution1(allocator, input)});
    std.debug.print("solution 2: {d}\n", .{try solution2(allocator, input)});
}

test "safety 0" {
    try std.testing.expect(is_safe(&.{ 7, 6, 4, 2, 1 }));
    try std.testing.expect(!is_safe(&.{ 1, 2, 7, 8, 9 }));
    try std.testing.expect(!is_safe(&.{ 9, 7, 6, 2, 1 }));
    try std.testing.expect(!is_safe(&.{ 1, 3, 2, 4, 5 }));
    try std.testing.expect(!is_safe(&.{ 8, 6, 4, 4, 1 }));
    try std.testing.expect(is_safe(&.{ 1, 3, 6, 7, 9 }));
}

test "safety 1" {
    try std.testing.expect(is_safe2(&.{ 7, 6, 4, 2, 1 }));
    try std.testing.expect(!is_safe2(&.{ 1, 2, 7, 8, 9 }));
    try std.testing.expect(!is_safe2(&.{ 9, 7, 6, 2, 1 }));
    try std.testing.expect(is_safe2(&.{ 1, 3, 2, 4, 5 }));
    try std.testing.expect(is_safe2(&.{ 8, 6, 4, 4, 1 }));
    try std.testing.expect(is_safe2(&.{ 1, 3, 6, 7, 9 }));
}

test "solution 1" {
    try std.testing.expectEqual(2, try solution1(std.testing.allocator, input_test));
}

test "solution 2" {
    try std.testing.expectEqual(4, try solution2(std.testing.allocator, input_test));
}
