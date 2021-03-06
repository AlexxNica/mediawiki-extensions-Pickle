--- Subclass to do specialization of the extractor strategy class
-- This is the spesialization to do casting into a nil type

-- pure libs
local Base = require 'picklelib/extractor/ExtractorStrategyBase'

-- @var class var for lib
local Extractor = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Extractor:__index( key ) -- luacheck: no self
	return Extractor[key]
end

-- @var metatable for the class
setmetatable( Extractor, { __index = Base } )

--- Create a new instance
-- @return self
function Extractor.create()
	local self = setmetatable( {}, Extractor )
	self:_init()
	return self
end

--- Initialize a new instance
-- @private
-- @return self
function Extractor:_init()
	Base._init( self,
		{ '^nil$', 0, 0 },
		{ '^nil[%s%p]', 0, -1 },
		{ '[%s%p]nil$', 1, 0 },
		{ '[%s%p]nil[%s%p]', 1, -1 } )
	self._type = 'nil'
	return self
end

--- Cast the string into the correct type for this strategy
-- There are no safeguards for erroneous casts
-- @param string used as the extraction source
-- @param number for an inclusive index where extraction starts
-- @param number for an inclusive index where extraction finishes
-- @return nil
function Extractor:cast( str, start, finish ) -- luacheck: ignore
	return nil
end

-- Return the final class
return Extractor
