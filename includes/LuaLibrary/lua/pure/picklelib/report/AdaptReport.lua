--- Subclass for adapt report

-- pure libs
local Stack = require 'picklelib/Stack'

-- non-pure libs
local BaseReport
if mw.pickle then
	-- structure exist, make access simpler
	BaseReport = mw.pickle.report.base
else
	-- structure does not exist, require the libs
	BaseReport = require 'picklelib/report/BaseReport'
end

-- @var class var for lib
local AdaptReport = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function AdaptReport:__index( key ) -- luacheck: no self
	return AdaptReport[key]
end

-- @var metatable for the class
setmetatable( AdaptReport, { __index = BaseReport } )

--- Create a new instance
-- @param vararg pushed to lines
-- @return AdaptReport
function AdaptReport.create( ... )
	local self = setmetatable( {}, AdaptReport )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg pushed to lines
-- @return AdaptReport
function AdaptReport:_init( ... )
	BaseReport._init( self )
	self._description = false
	self._lines = Stack.create()
	self._state = false
	self._lang = false
	self._lines:push( ... )
	self._skip = false
	self._todo = false
	self._type = 'adapt-report'
	return self
end

--- Export the lines as an multivalue return
-- Note that each line is not unwrapped.
-- @return list of lines
function AdaptReport:lines()
	return self._lines:export()
end

--- Get the number of lines
-- @return number of lines
function AdaptReport:numLines()
	local t = { self._lines:export() }
	return #t
end

--- Add a line
-- Note that all arguments will be wrapped up in a table before saving.
-- @param vararg that can be a line
-- @return self
function AdaptReport:addLine( ... )
	self._lines:push( { ... } )
	return self
end

--- Set the state unconditionally as "not ok""
-- Note that initial state is not ok.
-- @return self
function AdaptReport:notOk()
	self._state = false
	return self
end

--- Set the state unconditionally as "ok""
-- Note that initial state is not ok.
-- @return self
function AdaptReport:ok()
	self._state = true
	return self
end

--- Check if the instance state is "ok""
-- Note that initial state is not ok.
 --@return boolean that is set if state is "ok"
function AdaptReport:isOk()
	return self._state
end

--- Set the skip
-- This is an accessor to set the member.
-- Note that all arguments will be wrapped up in a table before saving.
-- @param string that will be used as the skip note
 --@return self
function AdaptReport:setSkip( str )
	--local t = { str }
	assert( str, 'Failed to provide a skip' )
	self._skip = str
	--self._skip = str
	return self
end

--- Get the skip
-- This is an accessor to get the member.
-- Note that the saved structure will be unpacked before being returned.
 --@return string used as the skip note
function AdaptReport:getSkip()
	return self._skip
end

--- Check if the instance is itself in a skip state
 --@return boolean that is set if a skip note exist
function AdaptReport:isSkip()
	return not not self._skip
end

--- Set the todo
-- This is an accessor to set the member.
-- @param string that will be used as the todo note
 --@return self
function AdaptReport:setTodo( str )
	assert( str, 'Failed to provide a todo' )
	self._todo = str
	return self
end

--- Get the todo
-- This is an accessor to get the member.
 --@return string used as the todo note
function AdaptReport:getTodo()
	return self._todo
end

--- Check if the instance is itself in a todo state
 --@return boolean that is set if a skip note exist
function AdaptReport:isTodo()
	return not not self._todo
end

--- Realize the data by applying a render
-- @param Renders to use while realizing the reports
-- @param string holding the language code
function AdaptReport:realize( renders, lang )
	assert( renders, 'Failed to provide renders' )
	return ''
		.. renders:realizeHeader( self, lang )
		.. renders:realizeBody( self, lang )
end

-- Return the final class
return AdaptReport
