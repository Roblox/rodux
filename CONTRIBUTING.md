# Contributing to Rodux
Thanks for considering contributing to Rodux! This guide has a few tips and guidelines to make contributing to the project as easy as possible.

## Bug Reports
Any bugs (or things that look like bugs) can be reported on the [GitHub issue tracker](https://github.com/Roblox/Rodux/issues).

Make sure you check to see if someone has already reported your bug first! Don't fret about it; if we notice a duplicate we'll send you a link to the right issue!

## Feature Requests
If there are any features you think are missing from Rodux, you can post a request in the [GitHub issue tracker](https://github.com/Roblox/Rodux/issues).

Just like bug reports, take a peak at the issue tracker for duplicates before opening a new feature request.

## Working on Rodux
To get started working on Rodux, you'll need:
* Git
* Lua 5.1
* [LuaFileSystem](https://keplerproject.github.io/luafilesystem/) (`luarocks install luafilesystem`)
* [LuaCov](https://keplerproject.github.io/luacov) (`luarocks install luacov`)
* [Foreman](https://github.com/Roblox/foreman) ([installation instructions](https://github.com/Roblox/foreman#installation))
* [Selene](https://github.com/Kampfkarren/selene) (`foreman install`, or download latest release into your `PATH`)
* [StyLua](https://github.com/JohnnyMorganz/StyLua) (`foreman install` -- you only need to run foreman once -- or download latest release into your `PATH`)

Before the tests will work, make sure you have all of the repository's Git submodules installed. If you haven't cloned it yet, you can use:

```sh
git clone --recurse-submodules https://github.com/Roblox/rodux.git
```

If you've already cloned the Rodux repository, you can use:

```sh
git submodule update --init
```

Finally, you can run all of Rodux's tests with:

```sh
lua test/lemur.lua
```

Or, to generate a LuaCov coverage report:

```sh
lua -lluacov spec.lua
luacov
```

## Pull Requests
Before starting a pull request, open an issue about the feature or bug. This helps us prevent duplicated and wasted effort. These issues are a great place to ask for help if you run into problems!

Before you submit a new pull request, check:
* Changelog: Add an entry to [CHANGELOG.md](CHANGELOG.md)
* Code Quality: Run [Selene](https://github.com/Kampfkarren/selene) on your code, no warnings allowed!
* Code Style: Run [StyLua](https://github.com/JohnnyMorganz/StyLua) on your code so it's formatted to follow the Roblox Lua Style Guide
* Tests: They all need to pass!
* Coverage: Code coverage of tests should not decrease.

### Code Style
Try to match the existing code style! In short:

* Tabs for indentation
* Double quotes
* One statement per line

Use StyLua to automatically format your code to comply with the Roblox Lua Style Guide.
You can run this tool manually from the commandline (`stylua -c src/`), or use one of StyLua's editor integrations.

### Changelog
Adding an entry to [CHANGELOG.md](CHANGELOG.md) alongside your commit makes it easier for everyone to keep track of what's been changed.

Add a line under the "Unreleased Changes" heading. When we make a new release, all of those bullet points will be attached to a new version and the "Unreleased Changes" section will become empty again.

### Tests
When submitting a bug fix, create a test that verifies the broken behavior and that the bug fix works. This helps us avoid regressions!

When submitting a new feature, add tests for all functionality.

We use [LuaCov](https://keplerproject.github.io/luacov) for keeping track of code coverage. We'd like it to be as close to 100% as possible, but it's not always easy.