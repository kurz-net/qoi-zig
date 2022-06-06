const std = @import("std");
const allocator = std.heap.page_allocator;
const ArrayList = std.ArrayList;

pub fn encode(_: []const u32) anyerror!ArrayList(u32) {
    var result = ArrayList(u32).init(allocator);

    return result;
}

pub fn main() anyerror!void {
    var hash: [20]u8 = undefined;
    std.crypto.hash.Sha1.hash("our data to hash", &hash, .{});
    std.log.info("our hash is: {s}", .{hash});
}

// pub fn main() anyerror!void {
//     var data = [_]u32{1, 2, 3};

//     var list = try encode(&data);
//     defer list.deinit();

//     try list.append(1);
//     try list.append(2);
//     try list.append(3);

//     std.log.info("the list has {d} items", .{list.items.len});
//     for (list.items) |item| {
//         std.log.info("i: {d}", .{item});
//     }
// }
