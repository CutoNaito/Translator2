const std = @import("std");
const allocator = std.heap.page_allocator;
const cmd_controller = @import("commands/translateCommandController.zig");
const conf = @import("readConf.zig").confReader();

const port: i32 = conf.port;
const address: []u8 = conf.ip;

pub fn main() !void {
    const server_options: std.net.StreamServer.Options = .{};
    var server = std.net.StreamServer.init(server_options);
    const server_addr = try std.net.Address.parseIp(address, port);

    if (server.listen(server_addr)) {
        std.log.info("Listening on port {}\n", .{port});
    } else {
        std.debug.print("Failed to listen on port {}\n", .{port});
        return;
    }

    while (true) {
        const connection = try server.accept();
        const reader = connection.stream.reader();
        const writer = connection.stream.writer();

        while (true) {
            if (reader.readAll()) |input| {
                writer.writeAll(cmd_controller.Controller(input));
            }
        }
    }
}
