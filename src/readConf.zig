const std = @import("std");

const Addr = union { ip: []u8, port: i32 };

pub fn confReader() !Addr {
    var buffer: [1024]u8 = undefined;
    var conf_file = try std.fs.cwd().openFile(".conf", .{});
    var address: Addr = undefined;

    while (try conf_file.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var splitted_line = std.mem.split(u8, line, "=");

        if (std.mem.eql(u8, splitted_line.first(), "IP")) {
            std.debug.print("{s}\n", .{splitted_line.next().?});
        }

        if (std.mem.eql(u8, splitted_line.first(), "PORT")) {
            address.port = std.fmt.parseInt(u8, splitted_line.next().?, 10);
        }
    }

    return address;
}
