load("@bazel_rules//doxygen:doxygen.bzl", "doxygen")

cc_library(
    name = "foo",
    hdrs = ["foo.h"],
    srcs = ["foo.cpp"],
)

cc_library(
    name = "bar",
    hdrs = ["bar.h"],
    srcs = ["bar.cpp"],
    deps = [
      ":foo",
    ],
)

doxygen(
    name = "docs",
    project_name = "Bar",
    mainpage = "mainpage.md",
    stylesheet = "@doxygen_awesome//:doxygen-awesome.css",
    inputs = [":bar"],
)
