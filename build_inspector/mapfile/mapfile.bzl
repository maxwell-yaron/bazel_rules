load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

RuleProvider = provider(
    fields = {
        "rule": "Rule for aspect"
    }
)

def _mapfile_transition_impl(settings, attr):
  updated = ['-Map','output.map']
  return {"//command_line_option:linkopt": updated}

mapfile_transition = transition(
    implementation = _mapfile_transition_impl,
    inputs = ["//command_line_option:linkopt"],
    outputs = ["//command_line_option:linkopt"],
)

def _collect_attrs_aspect(target, ctx):
  return RuleProvider(rule = ctx.rule)

def _mapfile_impl(ctx):
  src = ctx.attr.src
  out = ctx.actions.declare_file(ctx.label.name + '.map')
  ctx.actions.run_shell(
      outputs = [out],
      command = "cp output.map %s"%out.path,
  )

collect_rule_aspect = aspect(
    implementation = _collect_attrs_aspect,
)

mapfile = rule(
    implementation = _mapfile_impl,
    attrs = {
      "src": attr.label(
          mandatory = True,
          providers = [[CcInfo]],
          aspects = [collect_rule_aspect],
          cfg = mapfile_transition,
      ),
      "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
      "_allowlist_function_transition": attr.label(
          default = "@bazel_tools//tools/allowlists/function_transition_allowlist"
      )
    },
    fragments = ["cpp"],
)
