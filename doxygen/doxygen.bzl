def _doxybool(val):
  if val:
    return 'YES'
  else:
    return 'NO'

def _doxytarget(val):
  if val == None:
    return ''
  else:
    return val

SourceFileProvider = provider(
    fields = {
        'files': 'Header files',
    }
)

DoxygenProvider = provider(
    fields = {
        'doxyfile': 'Doxyfile',
        'outdir': 'Output directory',
        'stylesheet': 'Stylesheet',
        'inputs': 'Input files',
    }
)

def _collect_deps_aspect_impl(target, ctx):
  files = []
  if hasattr(ctx.rule.attr, "hdrs"):
    for target in ctx.rule.attr.hdrs:
      files += target.files.to_list()

  if hasattr(ctx.rule.attr, "srcs"):
    for target in ctx.rule.attr.srcs:
      files += target.files.to_list()
  
  if hasattr(ctx.rule.attr, "deps"):
    for target in ctx.rule.attr.deps:
      files += target[SourceFileProvider].files.to_list()

  return [SourceFileProvider(
      files = depset(files)
  )]

_collect_deps_aspect = aspect(
    implementation = _collect_deps_aspect_impl,
    attr_aspects = ["deps"]
)

def _expand_inputs(targets):
  files = []
  for t in targets:
    files += t[SourceFileProvider].files.to_list()
  return depset(files)

def _doxyfile_impl(ctx):
  excludes = _expand_inputs(ctx.attr.exclude)
  inputs = _expand_inputs(ctx.attr.inputs)
  mainpage = ctx.file.mainpage
  project_name = ctx.attr.project_name
  stylesheet = ctx.file.stylesheet
  warnings = _doxybool(ctx.attr.warnings)
  treeview = _doxybool(ctx.attr.treeview)
  generate_xml = _doxybool(ctx.attr.generate_xml)
  extra_files = ctx.files.extra_files

  input_names = [f.path for f in inputs.to_list()]
  exclude_names = [f.path for f in excludes.to_list()]
  extra_file_names = [f.path for f in extra_files]

  outdir = ctx.actions.declare_directory(ctx.label.name)
  ctx.actions.run_shell(
      outputs = [outdir],
      command = "mkdir -p %s"%outdir.path
  )

  doxyfile = ctx.actions.declare_file(ctx.label.name + '.Doxyfile')
  ctx.actions.expand_template(
      template = ctx.file._doxyfile_template,
      output = doxyfile,
      substitutions = {
          '${MAINPAGE}': mainpage.path,
          '${PROJECT_NAME}': '\"%s\"'%project_name,
          '${STYLESHEET}': stylesheet.path if stylesheet != None else '',
          '${WARNINGS}': warnings,
          '${TREEVIEW}': treeview,
          '${GENERATE_XML}': generate_xml,
          '${INPUTS}': ' '.join(input_names),
          '${EXCLUDES}': ' '.join(exclude_names),
          '${EXTRA_FILES}': ' '.join(extra_files),
          '${OUTPUT_DIRECTORY}': outdir.path,
      }
  )

  return [
      DefaultInfo(files=depset([doxyfile])),
      DoxygenProvider(doxyfile = doxyfile,
                      inputs = inputs,
                      outdir = outdir,
                      stylesheet = stylesheet,
      )
  ]

_doxyfile = rule(
    implementation = _doxyfile_impl,
    attrs = {
        "exclude": attr.label_list(aspects = [_collect_deps_aspect]),
        "hide_scope_names": attr.bool(default=True),
        "inputs": attr.label_list(mandatory=True, aspects = [_collect_deps_aspect]),
        "mainpage": attr.label(allow_single_file = ['.md'], mandatory=True),
        "project_name": attr.string(mandatory=True),
        "stylesheet": attr.label(allow_single_file=[".css"]),
        "warnings": attr.bool(default=True),
        "extra_files": attr.label_list(allow_files=True),
        "treeview": attr.bool(default=True),
        "generate_xml": attr.bool(default=False),
        "_doxyfile_template": attr.label(allow_single_file = True, default=Label("@bazel_rules//doxygen:Doxyfile.template")),
    }
)

def _doxygen_impl(ctx):
  executable = ctx.executable._run_doxygen
  doxyinfo = ctx.attr.doxyfile[DoxygenProvider]
  doxyfile = doxyinfo.doxyfile
  stylesheet = doxyinfo.stylesheet
  outdir = doxyinfo.outdir
  inputs = doxyinfo.inputs

  outpkg = ctx.actions.declare_file(ctx.label.name + ".tar.gz")

  args = [
      '--doxyfile',
      doxyfile.path,
      '--doxygen_tool',
      # TODO: Make this hermetic
      'doxygen',
      '--output',
      outpkg.path,
      '--srcdir',
      outdir.path
  ]

  ctx.actions.run(
      inputs = inputs.to_list() + [doxyfile, stylesheet],
      outputs = [outpkg],
      executable = executable,
      arguments = args,
  )


  return DefaultInfo(files=depset([outpkg]))

_doxygen = rule(
    implementation=_doxygen_impl,
    attrs = {
        'doxyfile': attr.label(providers = [DoxygenProvider], mandatory=True),
        '_run_doxygen': attr.label(executable=True,
                                   default=Label('@bazel_rules//doxygen:run_doxygen'),
                                   cfg= 'host',
                                   ),
    },
)

def doxygen(name, **kwargs):
  _doxyfile(
      name= name + '_doxyfile',
      **kwargs,
  )
  _doxygen(
      name = name,
      doxyfile = ':'+name+'_doxyfile',
  )
  native.py_binary(
      name = name + '_serve',
      srcs = ['@bazel_rules//doxygen:serve.py'],
      main = '@bazel_rules//doxygen:serve.py',
      args = [
          '--tarfile',
          '$(location :%s)'%name,
          '--dirname',
          name+'_doxyfile',
          '--execpath',
          '$(execpath :%s)'%name,
      ],
      data = [
          ':'+name
      ],
  )
