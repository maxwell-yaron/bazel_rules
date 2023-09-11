load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
load("@rules_cc//cc:action_names.bzl", "C_COMPILE_ACTION_NAME", "CPP_COMPILE_ACTION_NAME")

def _cc_compile(ctx, src):
  cc_toolchain = find_cpp_toolchain(ctx)
  src_file = src.files.to_list()[0]
  output = ctx.actions.declare_file(src_file.basename + ".o")
  feature_configuration = cc_common.configure_features(
      ctx = ctx,
      cc_toolchain = cc_toolchain,
      requested_features = ctx.features,
      unsupported_features = ctx.disabled_features,
  )

  if src_file.extension == 'c':
    compile_action = C_COMPILE_ACTION_NAME
    flags = ctx.fragments.cpp.copts + ctx.fragments.cpp.cxxopts 
  else:
    compile_action = CPP_COMPILE_ACTION_NAME
    flags = ctx.fragments.cpp.copts + ctx.fragments.cpp.conlyopts 

  compiler_path = cc_common.get_tool_for_action(
      feature_configuration = feature_configuration,
      action_name = compile_action,
  )

  compile_variables = cc_common.create_compile_variables(
      feature_configuration = feature_configuration,
      cc_toolchain = cc_toolchain,
      user_compile_flags = flags,
      source_file = src_file.path,
      output_file = output.path,
  )

  command_line = cc_common.get_memory_inefficient_command_line(
      feature_configuration = feature_configuration,
      action_name = compile_action,
      variables = compile_variables,
  )

  env = cc_common.get_environment_variables(
      feature_configuration = feature_configuration,
      action_name = compile_action,
      variables = compile_variables,
  )

  ctx.actions.run(
      executable = compiler_path,
      arguments = command_line,
      env = env,
      inputs = depset(
          [src_file],
          transitive = [cc_toolchain.all_files],
      ),
      outputs = [output],
  )

  return output;

def cc_compile(*, ctx, feature_configuration, cc_toolchain):
  deps_contexts = [d[CcInfo].compilation_context for d in ctx.attr.deps]
  compilation_context, outputs = cc_common.compile(
      name = ctx.label.name,
      actions = ctx.actions,
      feature_configuration = feature_configuration,
      cc_toolchain = cc_toolchain,
      srcs = ctx.files.srcs,
      compilation_contexts = deps_contexts,
  )
  return compilation_context, outputs

