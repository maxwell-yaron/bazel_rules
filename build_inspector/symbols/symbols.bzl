load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
load("@bazel_rules//build_inspector:collect_deps.bzl", "collect_deps","DepsProvider")

def _sanitize_fn(fn):
  return fn.replace('/','_')

def _nm_impl(ctx, src, options):
  cc_toolchain = find_cpp_toolchain(ctx)
  nm_tool = cc_toolchain.nm_executable
  out = ctx.actions.declare_file(_sanitize_fn(src.path) + '_nm.txt')
  cmd = [nm_tool] + options + [src.path]
  if src.extension == 'so':
    cmd.append('-D')
  cmd.extend(['>',out.path])

  ctx.actions.run_shell(
      inputs = cc_toolchain.all_files.to_list() + [src],
      outputs = [out],
      command = ' '.join(cmd),
  )
  return out;

def _symbols_dict(ctx, target, options):
  label = str(target.label)
  out = []
  for f in target.files.to_list():
    out.append(_nm_impl(ctx, f, options))
  return {label:out}

def _flatten(l):
  return [item for sublist in l for item in sublist]

def _symbols_json(d):
  out = {}
  for k,v in d.items():
    out[k] = []
    for item in v:
      out[k].append(item.path)
  return out;

def _symbols_impl(ctx):
  src = ctx.attr.src
  files = ctx.files.src
  # Target
  out = _symbols_dict(ctx, src, ['-g', '-C'])
  # Symbols for dependencies
  deps = src[DepsProvider].deps
  for d in deps.to_list():
    out.update(_symbols_dict(ctx, d, ['-g','-C','--defined-only']))

  all_files = depset(_flatten(out.values()))
  data = _symbols_json(out)
  outfile = ctx.actions.declare_file(ctx.label.name + '.json')
  args = ctx.actions.args()
  args.add_all([
      '--json',
      json.encode(data),
      '--outfile',
      outfile.path,
      '--target',
      src.label,
  ])
  ctx.actions.run(
      inputs = all_files,
      outputs = [outfile],
      executable = ctx.executable._symbol_report,
      arguments = [args],
  )
  return DefaultInfo(files = depset([outfile]))

symbols = rule(
    implementation = _symbols_impl,
    attrs = {
        'src': attr.label(
            mandatory=True,
            providers = [[CcInfo]],
            aspects = [collect_deps],
        ),
        '_symbol_report':attr.label(
            default = Label("@bazel_rules//build_inspector/symbols:symbol_report"),
            executable = True,
            cfg = "host",
        ),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
)
