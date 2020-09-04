local typefn = {
  ['nil'] = type,
  ['number'] = type,
  ['string'] = type,
  ['boolean'] = type,
  ['table'] = type,
  ['function'] = type,
  ['thread'] = type,
  ['userdata'] = type,
  ['file'] = io.type,
  ['closed file'] = io.type,
  ['integer'] = math.type,
  ['float'] = math.type,
}

local function fieldtype(v)
  local mt = getmetatable(v)
  local t

  if mt then
    t = mt.__name
    if not t then
      t = mt.__type
    end
  end
  return t
end

local M = {}
setmetatable(M, {__call = function(m, ...) return m.check(...) end})

-- Checks that the values conform to the types provided as first argument.
-- The types argument can be a single string for a single value, or an array
-- of strings.
--
-- The type string can be any of the type built-in function values, any of the
-- math.type or io.type values, or a value to match with the __name or __type
-- field of the value's metadata.
--
-- To support multiple types for a value, the pipe '|' character is used to
-- separate different type names. As a special case, '*' can be specified
-- to mean any non-nil value, it cannot be combined with any other type.
--
-- Returns the array of types that did match for each value.
function M.check(types, ...)
  if type(types) == 'string' then
    types = {types}
  end

  -- do not validate more values than we have types for
  local matches = {}
  for i, ts in ipairs(types) do
    local v = select(i, ...)
    local ok = false

    if ts == '*' then
      ok = v ~= nil
      table.insert(matches, type(v))
    else
      for t in string.gmatch(ts, '([^|]+)') do
        local fn = typefn[t] or fieldtype
        local got = fn(v)
        if got == t then
          ok = true
          table.insert(matches, got)
          break
        end
      end
    end

    if not ok then
      error(string.format('bad argument #%d (%s expected, got %s)', i, ts, type(v)))
    end
  end
  return matches
end

return M
