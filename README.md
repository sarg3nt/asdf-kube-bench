<div align="center">

# asdf-kube-bench [![Build](https://github.com/sarg3nt/asdf-kube-bench/actions/workflows/build.yml/badge.svg)](https://github.com/sarg3nt/asdf-kube-bench/actions/workflows/build.yml) [![Lint](https://github.com/sarg3nt/asdf-kube-bench/actions/workflows/lint.yml/badge.svg)](https://github.com/sarg3nt/asdf-kube-bench/actions/workflows/lint.yml)

[kube-bench](https://github.com/aquasecurity/kube-bench/blob/main/docs/index.md) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add kube-bench
# or
asdf plugin add kube-bench https://github.com/sarg3nt/asdf-kube-bench.git
```

kube-bench:

```shell
# Show all installable versions
asdf list-all kube-bench

# Install specific version
asdf install kube-bench latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kube-bench latest

# Now kube-bench commands are available
kube-bench version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/sarg3nt/asdf-kube-bench/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Dave Sargent](https://github.com/sarg3nt/)
