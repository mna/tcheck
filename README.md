# tcheck

A pure Lua module with no external dependency that provides simple sanity-checks of types for values. It doesn't aim to turn Lua into a typed language or anything fancy, it's just basically the equivalent of the `luaL_check...` functions in the Lua/C API that you will typically want to have at least on your public functions.

* Canonical repository: https://git.sr.ht/~mna/tcheck
* Issue tracker: https://todo.sr.ht/~mna/tcheck

## Install

Via Luarocks:

```
$ luarocks install tcheck
```

Or simply copy the single tcheck.lua file in your project or your `LUA_PATH`.

## API

Assuming `local tcheck = require 'tcheck'`. You can check out the tests for actual examples of using the API.

### `tcheck(types, ...)` or `tcheck.check(types, ...)`

Checks that the values conform to the types provided as first argument.
The types argument can be a single string for a single value, or an array
of strings.

The type string can be any of the type built-in function values, any of the
math.type or io.type values, or a value to match with the `__name` or `__type`
field of the value's metadata.

To support multiple types for a value, the pipe `|` character is used to
separate different type names. As a special case, `*` can be specified
to mean any non-nil value, it cannot be combined with any other type.

Returns the array of type names that did match for each value, or raises
an error if a value did not match.

## Development

Clone the project and install the required development dependencies:

* luaunit (unit test runner)
* luacov (recommended, test coverage)

If like me you prefer to keep your dependencies locally, per-project, then I recommend using my [llrocks] wrapper of the `luarocks` cli, which by default uses a local `lua_modules/` tree.

```
$ llrocks install ...
```

To run tests:

```
$ llrocks run test/main.lua
```

To view code coverage:

```
$ llrocks cover test/main.lua
```

## License

The [BSD 3-clause][bsd] license.

[bsd]: http://opensource.org/licenses/BSD-3-Clause
[llrocks]: https://git.sr.ht/~mna/llrocks
