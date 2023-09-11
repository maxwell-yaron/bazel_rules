load("//build_inspector/symbols:symbols.bzl", "symbols")
load("//build_inspector/mapfile:mapfile.bzl", "mapfile")
load("//cc_compile:cc_rules.bzl", "cxx_binary")

cc_library(
    name = "static_lib",
    hdrs = ["static_lib.h"],
    srcs = ["static_lib.cpp"],
    linkstatic = True,
)

cc_library(
    name = "dynamic_lib",
    hdrs = ["dynamic_lib.h"],
    srcs = ["dynamic_lib.cpp"],
    linkstatic = False,
)

cc_library(
    name = "generic_lib",
    hdrs = ["generic_lib.h"],
    srcs = ["generic_lib.cpp"],
    deps = [
        ":dynamic_lib",
        ":static_lib",
    ],
)

cc_binary(
    name = "example",
    srcs = ["example.cpp"],
    deps = [
        ":static_lib",
        ":dynamic_lib",
        ":generic_lib",
    ],
)

symbols(
    name = "example_symbols",
    src = ":example",
)

mapfile(
    name = "example_mapfile",
    src = ":example",
)

cxx_binary(
    name = "cxx_example",
    srcs = ["example.cpp"],
    deps = [
        ":static_lib",
        ":dynamic_lib",
        ":generic_lib",
    ],
)
