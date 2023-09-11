load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "with_feature_set",
    "tool_path",
)

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

all_compile_actions = [
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
]

def _flag_group(flags):
  if flags:
    return [flag_group(flags = flags)]
  else:
    return []

def _cc_toolchain_config_impl(ctx):
  tool_paths = [
      tool_path(name = name, path = path)
      for name, path in ctx.attr.tool_paths.items()
  ]

  link_flags_feature = feature(
      name = "linker_flags",
      enabled = True,
      flag_sets = [
          flag_set(
              actions = all_link_actions,
              flag_groups = _flag_group(ctx.attr.linkopts),
          ),
          flag_set(
              actions = all_link_actions,
              flag_groups = _flag_group(ctx.attr.linkopts_opt),
              with_features = [with_feature_set(features = ["opt"])]
          ),
          flag_set(
              actions = all_link_actions,
              flag_groups = _flag_group(ctx.attr.linkopts_dbg),
              with_features = [with_feature_set(features = ["dbg"])]
          ),
          flag_set(
              actions = all_link_actions,
              flag_groups = _flag_group(ctx.attr.linkopts_fastbuild),
              with_features = [with_feature_set(features = ["fastbuild"])]
          ),
      ],
  )

  compile_flags_feature = feature(
      name = "compile_flags",
      enabled = True,
      flag_sets = [
          flag_set(
              actions = all_compile_actions,
              flag_groups = _flag_group(ctx.attr.compile_flags),
          ),
          flag_set(
              actions = all_compile_actions,
              flag_groups = _flag_group(ctx.attr.compile_flags_opt),
              with_features = [with_feature_set(features = ["opt"])]
          ),
          flag_set(
              actions = all_compile_actions,
              flag_groups = _flag_group(ctx.attr.compile_flags_dbg),
              with_features = [with_feature_set(features = ["dbg"])]
          ),
          flag_set(
              actions = all_compile_actions,
              flag_groups = _flag_group(ctx.attr.compile_flags_fastbuild),
              with_features = [with_feature_set(features = ["fastbuild"])]
          ),
      ]
  )

  features = [
      link_flags_feature,
      compile_flags_feature,
  ]

  return cc_common.create_cc_toolchain_config_info(
      ctx = ctx,
      cxx_builtin_include_directories = ctx.attr.builtin_includes,
      toolchain_identifier = ctx.attr.toolchain_identifier,
      host_system_name = "local",
      target_system_name = "local",
      target_cpu = "arm",
      target_libc = "unknown",
      compiler = "gcc",
      abi_version = "unknown",
      abi_libc_version = "unknown",
      tool_paths = tool_paths,
      features = features,
  )


cc_toolchain_config = rule(
    implementation = _cc_toolchain_config_impl,
    attrs = {
        "toolchain_identifier": attr.string(mandatory = True),
        "target_cpu": attr.string(mandatory = True),
        "tool_paths": attr.string_dict(mandatory = True),
        "builtin_includes": attr.string_list(),
        "linkopts": attr.string_list(),
        "linkopts_opt": attr.string_list(),
        "linkopts_dbg": attr.string_list(),
        "linkopts_fastbuild": attr.string_list(),
        "compile_flags": attr.string_list(),
        "compile_flags_opt": attr.string_list(),
        "compile_flags_dbg": attr.string_list(),
        "compile_flags_fastbuild": attr.string_list(),
    },
    provides = [CcToolchainConfigInfo]
)
