const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zig-protobuf", "src/protobuf.zig");
    lib.setBuildMode(mode);
    lib.install();

    var tests = [_]*std.build.LibExeObjStep{
        b.addTest("src/protobuf.zig"),
        b.addTest("tests/tests.zig"),
        b.addTest("tests/encoding_alltypes.zig"),
    };

    const test_step = b.step("test", "Run library tests");
    for(tests) |test_item| {
        test_item.addPackage(.{
            .name = "protobuf",
            .path = "src/protobuf.zig"
        });
        test_item.setBuildMode(mode);
        test_step.dependOn(&test_item.step);
    }

}
