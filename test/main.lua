local lu = require 'luaunit'
local tcheck = require 'tcheck'

TestTcheck = {}
function TestTcheck.test_single_ok()
  local got = tcheck('string', 'a')
  lu.assertEquals(#got, 1)
  lu.assertEquals(got[1], 'string')
end

function TestTcheck.test_single_fail()
  lu.assertErrorMsgContains('bad argument #1', function()
    tcheck('string', 1)
  end)
end

function TestTcheck.test_many_ok()
  local got = tcheck({'string', 'number', 'boolean'}, 'a', 1.23, true)
  lu.assertEquals(#got, 3)
  lu.assertEquals(got, {'string', 'number', 'boolean'})
end

function TestTcheck.test_many_fail()
  lu.assertErrorMsgContains('bad argument #2', function()
    tcheck({'string', 'number', 'boolean'}, 'a', '4', true)
  end)
end

function TestTcheck.test_single_choice_ok()
  local got = tcheck('string|nil|number', 4)
  lu.assertEquals(#got, 1)
  lu.assertEquals(got[1], 'number')
end

function TestTcheck.test_single_choice_fail()
  lu.assertErrorMsgContains('bad argument #1', function()
    tcheck('string|nil|number', {})
  end)
end

function TestTcheck.test_many_extra()
  local got = tcheck('string|nil|number', 4, 'a', true)
  lu.assertEquals(#got, 1)
  lu.assertEquals(got[1], 'number')
end

function TestTcheck.test_any_ok()
  local got = tcheck('*', 4)
  lu.assertEquals(#got, 1)
  lu.assertEquals(got[1], 'number')
end

function TestTcheck.test_any_fail()
  lu.assertErrorMsgContains('bad argument #1', function()
    tcheck('*', nil)
  end)
end

local Class = {__name = 'Class'}
function TestTcheck.test_many_mt_name()
  local o = {}
  setmetatable(o, Class)
  local got = tcheck({'string|file|integer', 'boolean|Class'}, 3, o)
  lu.assertEquals(got, {'integer', 'Class'})
end

local Type = {__type = 'Type'}
function TestTcheck.test_many_mt_type()
  local o = {}
  setmetatable(o, Type)
  local got = tcheck({'string|file|integer', 'boolean|Class|Type'}, io.input(), o)
  lu.assertEquals(got, {'file', 'Type'})
end

os.exit(lu.LuaUnit.run())
