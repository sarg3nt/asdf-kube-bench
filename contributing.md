# Contributing

Testing Locally:

```shell
asdf plugin test kube-bench https://github.com/sarg3nt/asdf-kube-bench.git [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test kube-bench https://github.com/sarg3nt/asdf-kube-bench.git "kube-bench version"
```

Tests are automatically run in GitHub Actions on push and PR.
