--- Tests for the report module
-- This is a preliminary solution
-- @license GNU GPL v2+
-- @author John Erling Blad < jeblad@gmail.com >


local testframework = require 'Module:TestFramework'

local lib = require 'speclib/render/ReportRenderBase'
local name = 'reportRender'
local class = 'ReportRender'

local fix = require 'speclib/report/Result'

local function makeTest( ... )
	return lib.create( ... )
end

local function testExists()
	return type( lib )
end

local function testCreate( ... )
	return type( makeTest( ... ) )
end

local function testState( bool )
	local p = fix.create()
	if bool then
		p:ok()
	else
		p:notOk()
	end
	return makeTest():realizeState( p, 'qqx' )
end

local function testSkip( ... )
	local p = fix.create():setSkip( ... )
	return makeTest():realizeSkip( p, 'qqx' )
end

local function testTodo( ... )
	local p = fix.create():setTodo( ... )
	return makeTest():realizeTodo( p, 'qqx' )
end

local function testDescription( ... )
	local p = fix.create():setDescription( ... )
	return makeTest():realizeDescription( p, 'qqx' )
end

local function testHeaderSkip( ... )
	local p = fix.create():setDescription( 'testing' ):setSkip( ... ):notOk()
	return makeTest():realizeHeader( p, 'qqx' )
end

local function testHeaderTodo( ... )
	local p = fix.create():setDescription( 'testing' ):setTodo( ... ):ok()
	return makeTest():realizeHeader( p, 'qqx' )
end

local function testBody( ... )
	local p = fix.create():addLine( 'foo' ):addLine( 'bar' ):addLine( 'baz' )
	return makeTest():realizeBody( p, 'qqx' )
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
	  args = { 'a' },
	  expect = { 'table' }
	},
	{ name = name .. '.create (multiple value type)', func = testCreate, type='ToString',
	  args = { 'a', 'b', 'c' },
	  expect = { 'table' }
	},
	{ name = name .. '.state ()', func = testState,
	  args = { false },
	  expect = { '(spec-report-result-full-is-not-ok)' }
	},
	{ name = name .. '.state ()', func = testState,
	  args = { true },
	  expect = { '(spec-report-result-full-is-ok)' }
	},
	{ name = name .. '.skip ()', func = testSkip,
	  args = { 'foo' },
	  expect = { '(spec-report-result-full-wrap-skip: (foo))' }
	},
	{ name = name .. '.todo ()', func = testTodo,
	  args = { 'bar' },
	  expect = { '(spec-report-result-full-wrap-todo: bar)' }
	},
	{ name = name .. '.description ()', func = testDescription,
	  args = { 'baz' },
	  expect = { '(spec-report-result-full-wrap-description: baz)' }
	},
	{ name = name .. '.header ()', func = testHeaderSkip,
	  args = { 'baz' },
	  expect = { '(spec-report-result-full-is-not-ok)'
			.. '(spec-report-result-full-wrap-description: testing)'
			.. '# (spec-report-result-full-wrap-skip: (baz))' }
	},
	{ name = name .. '.header ()', func = testHeaderTodo,
	  args = { 'baz' },
	  expect = { '(spec-report-result-full-is-ok)'
			.. '(spec-report-result-full-wrap-description: testing)'
			.. '# (spec-report-result-full-wrap-todo: baz)' }
	},
	{ name = name .. '.body ()', func = testBody,
	  expect = { "\n"
			.. '(spec-report-result-full-wrap-line: (foo))' .. "\n"
			.. '(spec-report-result-full-wrap-line: (bar))' .. "\n"
			.. '(spec-report-result-full-wrap-line: (baz))' }
	},
}

return testframework.getTestProvider( tests )
