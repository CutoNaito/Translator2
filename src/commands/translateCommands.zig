const std = @import("std");

const Result = union {
    ok: []u8,
    err: []u8,
};

pub fn translateLocl(word: []u8) Result {
    var file = std.fs.cwd().openFile("localwords.csv", .{});
    var result: Result = undefined;
    const buffer: [1024]u8 = undefined;

    while (file.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var splitted = std.mem.split(u8, line, " ");

        if (splitted.first() == word) {
            result.ok = splitted.next().?;
            return result;
        }
    }

    result.err = "Word not found";
    return result;
}
