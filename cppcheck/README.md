# CPPCHECK - [Manual](https://cppcheck.sourceforge.io/manual.pdf)

To Include:

```python
load("@bazel_rules//:deps.bzl", "cppcheck_deps")
cppcheck_deps();       
```

To run (basic):
```bash
bazel run @cppcheck//:cppcheck -- --library=googletest.cfg --enable=all -i/path/to/ignore /path/to/code -I/path/to/code
```

To generate an HTML report
```bash
bazel run @cppcheck//:cppcheck -- --library=googletest.cfg --enable=all -i/path/to/ignore /path/to/code -I/path/to/code --xml --output-file=/path/to/output.xml

bazel run @cppcheck//:cppcheck-htmlreport -- --report-dir=/path/to/output/report/ --source-dir=/path/to/code --file=/path/to/output.xml
```
