--- Subclass for report renderer

-- pure libs
local Base = require 'speclib/render/ResultRenderBase'

-- @var class var for lib
local ResultRender = {}

--- Lookup of missing class members
function ResultRender:__index( key )
    return ResultRender[key]
end

-- @var metatable for the class
setmetatable( ResultRender, { __index = Base } )

--- Create a new instance
function ResultRender.create( ... )
    local self = setmetatable( {}, ResultRender )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function ResultRender:_init( ... )
    return self
end

--- Override key construction
function ResultRender:key( str )
    assert( str, 'Failed to provide a string' )
    return 'spec-report-result-full-' .. str
end

-- Return the final class
return ResultRender
