
def _make_readonly_output_directory_impl(ctx):
    output_dir = ctx.actions.declare_directory(ctx.label.name + "/dir")
    output_files = [output_dir]
    ctx.actions.run_shell(
        mnemonic = "MakeReadonlyDirectory",
        inputs = [],
        outputs = output_files,
        command = "mkdir -p $1; echo foo > $1/foo.txt; echo bar > $1/bar.txt; chmod -w $1",
        arguments = [output_dir.path],
    )

    return [
        DefaultInfo(
            files=depset(output_files),
        )
    ]

make_readonly_output_directory = rule(
    implementation = _make_readonly_output_directory_impl,
)
