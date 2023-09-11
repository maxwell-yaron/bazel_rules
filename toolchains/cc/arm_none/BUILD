load("@//tools/cc:toolchain.bzl", "cc_toolchain_config")

filegroup(
    name = "empty",
)

cc_toolchain_suite(
    name = "arm_none_suite",
    toolchains = {
        "k8": ":arm_none_toolchain",
    },
)

filegroup(
    name = "all_files",
    srcs = glob(["bin/**"]) + ["@linux-arm_none//:all_files"]
)

cc_toolchain_config(
    name = "arm_none_toolchain_config",
    toolchain_identifier = "arm_none-toolchain",
    target_cpu = "arm",
    tool_paths = {
        "gcc": "bin/gcc",
        "cpp": "bin/cpp",
        "ld": "bin/ld",
        "ar": "bin/ar",
        "gcov": "bin/gcov",
        "nm": "bin/nm",
        "objdump": "bin/objdump",
        "objcopy": "bin/objcopy",
        "strip": "bin/strip",
    },
    compile_flags = [
        "-nostdinc",
        "-isystem",
        "external/linux-arm_none/arm-none-eabi/include/c++/10.3.1",
        "-isystem",
        "external/linux-arm_none/arm-none-eabi/include/",
        "-isystem",
        "external/linux-arm_none/lib/gcc/arm-none-eabi/10.3.1/include/",
        "-isystem",
        "external/linux-arm_none/lib/gcc/arm-none-eabi/10.3.1/include-fixed/",
        "-isystem",
        "external/linux-arm_none/arm-none-eabi/include/c++/10.3.1/arm-none-eabi",
        "-isystem",
        "external/linux-arm_none/arm-none-eabi/include/c++/10.3.1/tr1",
        "-Wall",
        "-Wextra",
        "-Werror",
        "-std=c++14",
        "-fdata-sections",
        "-ffunction-sections",
        "-fno-builtin",
        "-mthumb",
        "-fno-exceptions",
        "-Wno-unused-parameter",
        "-Wno-builtin-macro-redefined",
        "-D__DATE__=\"redacted\"",
        "-D__TIMESTAMP__=\"redacted\"",
        "-D__TIME__=\"redacted\"",
    ],
    compile_flags_opt = [
        "-g0",
        "-DNDEBUG",
        "-O2",
    ],
    compile_flags_dbg = [
        "-g"
    ],
    compile_flags_fastbuild = [
        "-g1",
        "-O2",
    ],
    linkopts = [
        "-nodefaultlibs",
        "-Lexternal/linux-arm_none/lib/gcc/arm-none-eabi/10.3.1",
        "-Lexternal/linux-arm_none/arm-none-eabi/lib",
        "-lc",
        "-lstdc++",
        "-lgcc",
        "-lg",
        "-lm",
        "-Wl,-nostdlib",
        "-lnosys",
    ],
    linkopts_opt = [
        "-Wl,--gc-sections",
    ],
    linkopts_dbg = [
        "-lrdimon",
    ],
)

cc_toolchain(
    name = "arm_none_cc_toolchain",
    toolchain_identifier = "arm_none-toolchain",
    all_files = ":all_files",
    ar_files = ":all_files",
    compiler_files = ":all_files",
    dwp_files = ":all_files",
    linker_files = ":all_files",
    objcopy_files = ":all_files",
    strip_files = ":all_files",
    supports_param_files = 0,
    toolchain_config = ":arm_none_toolchain_config",
)

toolchain(
    name = "arm_none_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:none",
        "@platforms//cpu:arm",
    ],
    toolchain = ":arm_none_cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

