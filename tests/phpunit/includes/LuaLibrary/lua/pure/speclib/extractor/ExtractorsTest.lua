--- Tests for the extractor strategies module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'speclib/extractor/Extractors'
local name = 'extractor'

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testFind( str, ... )
	local t = { makeTest( ... ):find( str, 1 ) }
  local obj = table.remove( t, 1 )
  table.insert( t, obj:type() )
  return unpack( t )
end

local tests = {
  { name = name .. ' exists', func = testExists, type='ToString',
    expect = { 'table' }
  },
  { name = name .. '.create (nil value type)', func = testCreate, type='ToString',
    args = { nil },
    expect = { 'table' }
  },
  { name = name .. '.create (single value type)', func = testCreate, type='ToString',
    args = { require 'speclib/extractor/NilExtractorStrategy' },
    expect = { 'table' }
  },
  { name = name .. '.create (single value type)', func = testCreate, type='ToString',
    args = { require 'speclib/extractor/FalseExtractorStrategy' },
    expect = { 'table' }
  },
  { name = name .. '.create (single value type)', func = testCreate, type='ToString',
    args = { require 'speclib/extractor/TrueExtractorStrategy' },
    expect = { 'table' }
  },
  { name = name .. '.create (single value type)', func = testCreate, type='ToString',
    args = { require 'speclib/extractor/StringExtractorStrategy' },
    expect = { 'table' }
  },
  { name = name .. '.create (single value type)', func = testCreate, type='ToString',
    args = { require 'speclib/extractor/NumberExtractorStrategy' },
    expect = { 'table' }
  },
  { name = name .. '.find (nil extract)', func = testFind,
    args = { 'foo nil bar', require('speclib/extractor/NilExtractorStrategy').create() },
    expect = { 5, 7, 'nil' }
  },
  { name = name .. '.find (false extract)', func = testFind,
    args = { 'foo false bar', require('speclib/extractor/FalseExtractorStrategy').create() },
    expect = { 5, 9, 'false' }
  },
  { name = name .. '.find (true extract)', func = testFind,
    args = { 'foo true bar', require('speclib/extractor/TrueExtractorStrategy').create() },
    expect = { 5, 8, 'true' }
  },
  { name = name .. '.find (string extract)', func = testFind,
    args = { 'foo "test" bar', require('speclib/extractor/StringExtractorStrategy').create() },
    expect = { 6, 9, 'string' }
  },
  { name = name .. '.find (number extract)', func = testFind,
    args = { 'foo 42 bar', require('speclib/extractor/NumberExtractorStrategy').create() },
    expect = { 5, 6, 'number' }
  },
}

return testframework.getTestProvider( tests )