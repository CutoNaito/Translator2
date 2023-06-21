const std = @import("std");
const cmd = @import("translateCommands.zig");

pub fn Controller(input: []u8) []u8 {
    const command = try std.mem.split(u8, input, "\"");
    var result: []u8 = undefined;
    var err: []u8 = undefined;

    if (std.mem.eql(u8, command.first(), "TRANSLATELOCL")) {
        result = cmd.translateLocl(command.next().?).ok;
        err = cmd.translateLocl(command.next().?).err;

        if (err) {
            return err;
        } else {
            return result;
        }
    }
}
