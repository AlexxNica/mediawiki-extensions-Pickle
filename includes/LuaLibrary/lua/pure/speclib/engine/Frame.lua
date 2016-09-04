-- Baseclass for Describe, Context, and It

-- pure libs
local Stack = require 'speclib/Stack'
local util = require 'speclib/util'

-- non-pure libs
local Plan
local Subject
if mw.spec then
    -- structure exist, make access simpler
    Plan = mw.spec.stack
    Subject = mw.spec.subject
else
    -- structure does not exist, require the libs
    Plan = require 'speclib/report/Plan'
    Subject = require 'speclib/engine/Subject'
end

-- @var class var for lib
local Frame = {}

--- Lookup of missing class members
function Frame:__index( key )
    return Frame[key]
end

-- @var metatable for the class
local mt = {}

--- Get arguments for a class call
function mt:__call( ... )
    local obj = Frame.create()
    obj:dispatch( ... )
    assert( not obj:isDone(), 'Failed, got a done instanc' )
    if obj:hasFixtures( obj ) then
        obj:eval()
    end
    return obj
end

--- Get arguments for a instance call
function Frame:__call( ... )
    self:dispatch( ... )
    assert( not self:isDone(), 'Failed, got a done instanc' )
    if self:hasFixtures() then
        self:eval()
    end
    return self
end

setmetatable( Frame, mt )

--- Create a new instance
function Frame.create( ... )
    local self = setmetatable( {}, Frame )
    self:_init( ... )
    return self
end

--- Initialize a new instance
function Frame:_init( ... )
    self._descriptions = Stack.create()
    self._fixtures = Stack.create()
    self._depth = Subject.stack:depth()
    self._done = false
    self:dispatch( ... )
    return self
end

--- Dispach on type
function Frame:dispatch( ... )
    for _,v in ipairs( { ... } ) do
        local tname = type( v )..'Type'
        assert( self[tname], 'Failed to find a type handler' )
        self[tname]( self, v )
    end
    return self
end

--- Push a string
function Frame:stringType( ... )
    self._descriptions:push( ... )
end

--- Push a function
function Frame:functionType( ... )
    self._fixtures:push( ... )
end

--- Push a table
function Frame:tableType( ... )
    Subject.stack:push( ... )
end

--- Check if the frame has fixtures
function Frame:hasFixtures()
    return not self._fixtures:isEmpty()
end

--- Check if the instance is evaluated
function Frame:isDone()
    return self._done
end

--- Get descriptions
function Frame:descriptions()
    return self._descriptions:export()
end

--- Eval the fixtures
function Frame:eval( ... )
    for _,v in ipairs( { self._descriptions:export() } ) do
        for _,w in ipairs( { self._fixtures:export() } ) do
            -- @todo following should use xpcall
            w( v )
            -- @todo following should capture content on stack
            --Plan.create(  )
        end
    end
    self._eval = true
    return self
end

-- Return the final class
return Frame
