const std = @import("std");
const allocator = std.heap.page_allocator;
const cmd_controller = @import("commands/translateCommandController.zig");
const conf = @import("readConf.zig");

pub fn main() !void {
    const address_union = try conf.confReader();
    const address = address_union.ip;
    const port = address_union.port;
    const server_options: std.net.StreamServer.Options = .{};
    var server = std.net.StreamServer.init(server_options);
    const server_addr = try std.net.Address.parseIp(address, port);

    if (server.listen(server_addr)) |_| {
        std.log.info("Listening on port {}\n", .{port});
    } else {
        std.debug.print("Failed to listen on port {}\n", .{port});
        return;
    }

    while (true) {
        const connection = try server.accept();
        const reader = connection.stream.reader();
        const writer = connection.stream.writer();
        var buffer: [1024]u8 = undefined;

        while (true) {
            if (try reader.readAll(&buffer)) |input| {
                writer.writeAll(cmd_controller.Controller(input));
            }
        }
    }
}
