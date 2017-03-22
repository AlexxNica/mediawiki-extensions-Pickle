-- Class for render strategies

-- @var class var for lib
local Renders = {}

--- Lookup of missing class members
-- @param string used for lookup of member
-- @return any
function Renders:__index( key ) -- luacheck: no self
	return Renders[key]
end

-- @var class var for styles, holding references to created renders
Renders._styles = {}

--- Convenience function to access a specific named style
-- This will try to create the style if it isn't created yet.'
-- @return Render
function Renders:__call( name ) -- luacheck: no self
	assert( name, 'Failed to provide a name' )
	assert( Renders._styles[name], 'Failed to provide a previously registered style' )
	return Renders._styles[name]
end

--- Register named style
-- This is at class level. It is really a two level strategy, but we're lazy
-- and skip one of the levels.
-- @param string name of a style of rendering
-- @return Render
function Renders.registerStyle( name )
	if not Renders._styles[name] then
		Renders._styles[name] = Renders.create( name )
	end
	return Renders._styles[name]
end

--- Create a new instance
-- @param name of a style of rendering
-- @return self
function Renders.create( name )
	local self = setmetatable( {}, Renders )
	self:_init( name )
	return self
end

--- Initialize a new instance
-- @private
-- @param string name of a style of rendering
function Renders:_init( name )
	assert( name, 'Failed to provide a name' )
	self._style = name
	self._types = {}
end

--- Register a render of given named type
-- This will typically be "Result" or "Report".
-- @param string name of a style of rendering
-- @param Render lib for the specific kind of rendering
-- @return Render
function Renders:registerType( name, lib )
	assert( name, 'Failed to provide a name' )
	self._types[name] = lib
	return self._types[name]
end

--- Find render of the correct named type
-- This will typically be "Result" or "Report".
-- @todo check if this has tests
-- @param string name of a style of rendering
-- @return Render
function Renders:find( name )
	assert( name, 'Failed to provide a name' )
	assert( self._types[name], 'Failed to provide a previously registered type' )
	return self._types[name]
end

-- Return the final class
return Renders
