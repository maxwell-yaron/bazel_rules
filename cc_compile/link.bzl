load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
load("@rules_cc//cc:action_names.bzl", "CPP_LINK_STATIC_LIBRARY_ACTION_NAME", "CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME", "CPP_LINK_EXECUTABLE_ACTION_NAME")

def _type_info(tp):
  if tp == 'static':
    return struct(
        extension = '.a',
        action_name = CPP_LINK_STATIC_LIBRARY_ACTION_NAME,
        using_linker = False,
        is_dynamic = False,
    )
  elif tp == 'dynamic':
    return struct(
        extension = '.so',
        action_name = CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
        using_linker = True,
        is_dynamic = True,
    )
  elif tp == 'executable':
    return struct(
        extension = '',
        action_name = CPP_LINK_EXECUTABLE_ACTION_NAME,
        using_linker = True,
        is_dynamic = False,
    )
  else:
    fail("Unknown type", tp)

def _cc_link(ctx, compilation_context, srcs, tp, alwayslink = False):
  type_info = _type_info(tp)
  cc_toolchain = find_cpp_toolchain(ctx)
  output = ctx.actions.declare_file(ctx.label.name + type_info.extension)
  mapfile = ctx.actions.declare_file(ctx.label.name + ".map")

  feature_configuration = cc_common.configure_features(
      ctx = ctx,
      cc_toolchain = cc_toolchain,
      requested_features = ctx.features,
      unsupported_features = ctx.disabled_features,
  )

  if tp == 'static':
    library_to_link = cc_common.create_library_to_link(
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        static_library = output,
        alwayslink = alwayslink,
    )
  elif tp == 'dynamic':
    library_to_link = cc_common.create_library_to_link(
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        dynamic_library = output,
        alwayslink = alwayslink,
    )

  linker_input = cc_common.create_linker_input(
      owner = ctx.label,
      libraries = depset(direct = [library_to_link]),
  )
  linking_context = cc_common.create_linking_context(linker_inputs = depset(direct = [linker_input]))

  tool_path = cc_common.get_tool_for_action(
      feature_configuration = feature_configuration,
      action_name = type_info.action_name,
  )

  variables = cc_common.create_link_variables(
      feature_configuration = feature_configuration,
      cc_toolchain = cc_toolchain,
      output_file = output.path,
      is_using_linker = type_info.using_linker,
      is_linking_dynamic_library = type_info.is_dynamic,
  )

  command_line = cc_common.get_memory_inefficient_command_line(
      feature_configuration = feature_configuration,
      action_name = type_info.action_name,
      variables = variables,
  )

  args = ctx.actions.args()
  args.add_all(command_line)
  args.add_all(["-Map", mapfile.path])
  args.add_all(srcs)

  env = cc_common.get_environment_variables(
      feature_configuration = feature_configuration,
      action_name = type_info.action_name,
      variables = variables,
  )

  ctx.actions.run(
      executable = tool_path,
      arguments = [args],
      env = env,
      inputs = depset(
          direct = srcs,
          transitive = [cc_toolchain.all_files]
      ),
      outputs = [output, mapfile],
  )
  return struct(
      compilation_context = compilation_context,
      linking_context = linking_context,
      output = output,
      mapfile = mapfile
  )

def cc_link(*, ctx, feature_configuration, cc_toolchain, compilation_outputs):
  mapfile = ctx.actions.declare_file(ctx.label.name + '.map')
  deps_linking = [d[CcInfo].linking_context for d in ctx.attr.deps]
  print(cc_toolchain)
  linking_outputs = cc_common.link(
      actions = ctx.actions,
      name = ctx.label.name,
      feature_configuration = feature_configuration,
      cc_toolchain = cc_toolchain,
      compilation_outputs = compilation_outputs,
      linking_contexts = deps_linking,
      user_link_flags = ["-Wl,-Map=%s"%mapfile.path, '-dy','-lpthread', '-lm'],
      additional_outputs = [mapfile],
  )
  return linking_outputs, mapfile
