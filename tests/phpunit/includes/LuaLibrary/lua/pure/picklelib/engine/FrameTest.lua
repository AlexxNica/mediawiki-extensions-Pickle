--- Tests for the frame module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'picklelib/engine/Frame'
local name = 'frame'
local class = 'Frame'

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testClassCall( ... )
	local t = lib( ... )
	return t:descriptions()
end

local function testClassCallStrings()
	local t = lib 'foo' 'bar' 'baz'
	return t:descriptions()
end

local function testInstanceCall( ... )
	local obj = makeTest()
	local t = obj( ... )
	return t:descriptions()
end

local function testInstanceCallStrings()
	local obj = makeTest()
	local t = obj 'foo' 'bar' 'baz'
	return t:descriptions()
end

local function testStringDispatch( ... )
	local obj = makeTest()
	obj:dispatch( ... )
	return obj:hasDescriptions(), obj:numDescriptions(), obj:descriptions()
end

local function testFunctionDispatch( ... )
	local obj = makeTest()
	obj:dispatch( ... )
	return obj:hasFixtures(), obj:numFixtures()
end

local function testTableDispatch( ... )
	local obj = makeTest()
	obj:dispatch( ... )
	return obj:numSubjects()
end

local function testEval( libs, ... )
	local obj = makeTest( ... )
	for _,v in ipairs( libs ) do
		obj:extractors():register( require( v ).create() )
	end
	return obj:eval()
end

local tests = {
	{
		name = name .. ' exists',
		func = testExists,
		type = 'ToString',
		expect = { 'table' }
	},
	{
		name = name .. '.create (nil value type)',
		func = testCreate,
		type = 'ToString',
		args = { nil },
		expect = { 'table' }
	},
	{
		name = name .. '.create (single value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a' },
		expect = { 'table' }
	},
	{
		name = name .. '.create (multiple value type)',
		func = testCreate,
		type = 'ToString',
		args = { 'a', 'b', 'c' },
		expect = { 'table' }
	},
	{
		name = class .. '.call (single value type)',
		func = testClassCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = class .. '.call (multiple value type)',
		func = testClassCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{
		name = class .. '.call (multiple strings)',
		func = testClassCallStrings,
		expect = { 'foo', 'bar', 'baz' }
	},
	{
		name = name .. '.call (single value type)',
		func = testInstanceCall,
		args = { 'a' },
		expect = { 'a' }
	},
	{
		name = name .. '.call (multiple value type)',
		func = testInstanceCall,
		args = { 'a', 'b', 'c' },
		expect = { 'a', 'b', 'c' }
	},
	{
		name = name .. '.call (multiple strings)',
		func = testInstanceCallStrings,
		expect = { 'foo', 'bar', 'baz' }
	},
	{
		name = name .. '.stringDispatch (no string)',
		func = testStringDispatch,
		args = { },
		expect = { false, 0 }
	},
	{
		name = name .. '.stringDispatch (single string)',
		func = testStringDispatch,
		args = { 'foo' },
		expect = { true, 1, 'foo' }
	},
	{
		name = name .. '.stringDispatch (multiple string)',
		func = testStringDispatch,
		args = { 'foo', 'bar', 'baz' },
		expect = { true, 3, 'foo', 'bar', 'baz' }
	},
	{
		name = name .. '.functionDispatch (no function)',
		func = testFunctionDispatch,
		args = {},
		expect = { false, 0 }
	},
	{
		name = name .. '.functionDispatch (single function)',
		func = testFunctionDispatch,
		args = { function() return 'foo' end },
		expect = { true, 1 }
	},
	{
		name = name .. '.functionDispatch (multiple functions)',
		func = testFunctionDispatch,
		args = {
			function() return 'foo' end,
			function() return 'bar' end,
			function() return 'baz' end
		},
		expect = { true, 3 }
	},
	{
		name = name .. '.tableDispatch (no table)',
		func = testTableDispatch,
		args = {},
		expect = { 0 }
	},
	{
		name = name .. '.tableDispatch (single table)',
		func = testTableDispatch,
		args = { { 'foo' } },
		expect = { 1 }
	},
	{
		name = name .. '.tableDispatch (multiple tables)',
		func = testTableDispatch,
		args = {
			{ 'foo' },
			{ 'bar' },
			{ 'baz' }
		},
		expect = { 3 }
	},
	--[[
	{
		name = name .. '.eval ("foo bar baz")',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			"foo bar baz"
		},
		expect = { 3 }
	},
	{
		name = name .. '.eval ("foo \\\"test\\\" baz")',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			"foo \"test\" baz"
		},
		expect = { 3 }
	},
	{
		name = name .. '.eval ("foo 42 baz")',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			"foo 42 baz"
		},
		expect = { 3 }
	},
	{
		name = name .. '.eval ("foo \\\"test\\\" bar 42 baz")',
		func = testEval,
		args = {
			{
				"picklelib/extractor/StringExtractorStrategy",
				"picklelib/extractor/NumberExtractorStrategy"
			},
			"foo \"test\" bar 42 baz"
		},
		expect = { 3 }
	},
	]]
}

return testframework.getTestProvider( tests )
