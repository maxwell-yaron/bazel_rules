# Bazel Rules

Build rules for various third party libraries

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")                       
http_archive(
  name = "bazel_rules",    
  urls = ["https://github.com/maxwell-yaron/bazel_rules/archive/refs/tags/<RELEASE>.tar.gz"],
  strip_prefix = "bazel_rules-<RELEASE>",
  sha256 = "<SHA256>"
)                                 
```
