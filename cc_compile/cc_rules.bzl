load("@bazel_rules//cc_compile:compile.bzl","cc_compile")
load("@bazel_rules//cc_compile:link.bzl","cc_link")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

def _cxx_binary_impl(ctx):
  cc_toolchain = find_cpp_toolchain(ctx) 
  feature_configuration = cc_common.configure_features(
      ctx = ctx,
      cc_toolchain = cc_toolchain,
      requested_features = ctx.features,
      unsupported_features = ctx.disabled_features,
  )
  compilation_context, compilation_outputs = cc_compile(
      ctx = ctx,
      feature_configuration = feature_configuration,
      cc_toolchain = cc_toolchain,
  )
  linking_outputs, mapfile = cc_link(
      ctx = ctx,
      feature_configuration = feature_configuration,
      cc_toolchain = cc_toolchain,
      compilation_outputs = compilation_outputs,
  )
  linking_context= cc_common.create_linking_context(linker_inputs=depset([]))

  cc_info = cc_common.merge_cc_infos(cc_infos = [
      CcInfo(
          compilation_context = compilation_context,
          linking_context = linking_context
      ),
    ] + [dep[CcInfo] for dep in ctx.attr.deps])
  default_info = DefaultInfo(
      files = depset([mapfile]),
      executable = linking_outputs.executable,
  )
  return [default_info, cc_info]

cxx_binary = rule(
    implementation = _cxx_binary_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".c", ".cc",".cpp"]),
        "deps": attr.label_list(providers = [[CcInfo]]),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    fragments = ["cpp"],
)
