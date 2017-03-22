--- Subclass for report renderer

-- pure libs
local Base = require 'picklelib/render/AdaptReportRenderBase'

-- @var class var for lib
local AdaptReportRender = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function AdaptReportRender:__index( key ) -- luacheck: no self
	return AdaptReportRender[key]
end

-- @var metatable for the class
setmetatable( AdaptReportRender, { __index = Base } )

--- Create a new instance
-- @param vararg unused
-- @return AdaptReportRender
function AdaptReportRender.create( ... )
	local self = setmetatable( {}, AdaptReportRender )
	self:_init( ... )
	return self
end

--- Initialize a new instance
-- @private
-- @param vararg unused
-- @return AdaptReportRender
function AdaptReportRender:_init( ... ) -- luacheck: no unused args
	return self
end

--- Override key construction
-- @param string to be appended to a base string
-- @return string
function AdaptReportRender:key( str )
	return 'pickle-report-adapt-full-' ..  Base.key( self, str )
end

-- Return the final class
return AdaptReportRender
