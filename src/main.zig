const std = @import("std");
const allocator = std.heap.page_allocator;
const ArrayList = std.ArrayList;

pub fn encode() anyerror!ArrayList(u32) {
    var result = ArrayList(u32).init(allocator);
    return result;
}

pub fn main() anyerror!void {
    var list = try encode();
    defer list.deinit();

    try list.append(1);
    try list.append(2);
    try list.append(3);

    std.log.info("the list has {d} items", .{list.items.len});
    for (list.items) |item| {
        std.log.info("i: {d}", .{item});
    }
}
