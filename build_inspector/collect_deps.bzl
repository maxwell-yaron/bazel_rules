DepsProvider = provider(
    fields = {
        "deps": "depset of all deps",
    },
)

def _collect_deps_impl(target, ctx):
  deps = []
  if hasattr(ctx.rule.attr, "deps"):
    deps.extend(ctx.rule.attr.deps)
  return DepsProvider(deps = depset(deps))

collect_deps = aspect(
    implementation = _collect_deps_impl,
    attr_aspects = ["deps"],
)
