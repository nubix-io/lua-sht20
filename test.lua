print('Begin test')

-- ============================================================================
-- Mini test framework
-- ============================================================================

local failures = 0

local function assertEquals(expected,actual,message)
  message = message or string.format('Expected %s but got %s', tostring(expected), tostring(actual))
  assert(actual==expected, message)
end

local function it(message, testFn)
  local status, err =  pcall(testFn)
  if status then
    print(string.format('✓ %s', message))
  else
    print(string.format('✖ %s', message))
    print(string.format('  FAILED: %s', err))
    failures = failures + 1
  end
end


-- ============================================================================
-- sht20 module
-- ============================================================================

it('readShort', function()
  local sht20 = require 'sht20.modbus'
  local msb, lsb = 215, 84
  assertEquals(-10412, sht20.readShort(lsb, msb))
end) 
