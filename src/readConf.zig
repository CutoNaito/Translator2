const std = @import("std");

const Addr = union { ip: []const u8, port: u16 };

pub fn confReader() !Addr {
    var buffer: [1024]u8 = undefined;
    var conf_file = try std.fs.cwd().openFile(".conf", .{});
    var address: Addr = undefined;

    while (try conf_file.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var splitted_line = std.mem.split(u8, line, "=");

        if (std.mem.eql(u8, splitted_line.first(), "IP")) {
            address.ip = splitted_line.next().?;
        }

        if (std.mem.eql(u8, splitted_line.first(), "PORT")) {
            address.port = try std.fmt.parseInt(u16, splitted_line.next().?, 10);
        }
    }

    return address;
}
