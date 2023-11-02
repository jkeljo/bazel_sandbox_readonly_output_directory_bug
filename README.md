This reproduces what I believe to be a bug in Bazel when a rule that produces
a read-only directory as output is run in the hermetic sandbox.

To repro, install Bazelisk and run `bazelisk build -s //:test`

Bazel will fail with "I/O exception during sandboxed execution: Could not move output artifacts from sandboxed execution".

Running outside the sandbox or removing the `chmod -w` from `rule.bzl` allows
this to succeed.

```
(11:49:29) INFO: Current date is 2023-11-02
(11:49:30) INFO: Analyzed target //:test (4 packages loaded, 6 targets configured).
(11:49:30) INFO: Found 1 target...
(11:49:31) SUBCOMMAND: # //:test [action 'MakeReadonlyDirectory test/dir', configuration: eae08a0147418bbed67463ae5f68913a92ab5c68abe9a3a6ea98eee64dbbdd8a, execution platform: @local_config_platform//:host]
(cd /home/jkeljo/.cache/bazel/_bazel_jkeljo/b2b1b4d62a8233116aa0902a70e46dcb/execroot/__main__ && \
    exec env - \
    /bin/bash -c 'mkdir -p $1; echo foo > $1/foo.txt; echo bar > $1/bar.txt; chmod -w $1' '' bazel-out/k8-fastbuild/bin/test/dir)
(11:49:31) ERROR: /home/jkeljo/bazel_bugreports/bazel_sandbox_readonly_output_directory_bug/BUILD:3:31: MakeReadonlyDirectory test/dir failed: I/O exception during sandboxed execution: Could not move output artifacts from sandboxed execution
Target //:test failed to build
Use --verbose_failures to see the command lines of failed build steps.
(11:49:31) INFO: Elapsed time: 2.401s, Critical Path: 0.17s
(11:49:31) INFO: 2 processes: 2 internal.
(11:49:31) FAILED: Build did NOT complete successfully
```
