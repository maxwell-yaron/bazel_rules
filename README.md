# Bazel Rules

Build rules for various third party libraries

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")                       
http_archive(
  name = "bazel_rules",
  urls = ["https://github.com/maxwell-yaron/bazel_rules/tarball/main"],
  type = [".tar.gz"],
)

load("@bazel_tools//:deps.bzl", "cppcheck_deps")
cppcheck_deps();
```
