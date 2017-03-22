-- module to support Pickle
-- @provenance ideas from Moses [https://github.com/Yonaba/Moses/blob/master/moses.lua]
-- @author John Erling Blad < jeblad@gmail.com >

-- @var Table holding the modules exported members
local util = {}

--- Transform names in camel case into hyphen separated keys
-- @param string in camel case
-- @return hyphenated string
function util.buildName( str )
	return str:gsub("([A-Z])", function(s) return '-'..string.lower(s) end )
end

-- raw count of all the items in the provided table
-- @provenance variant of 'local function count(t)' from "Moses"
-- @param t table that has its entries counted
-- @return count of raw entries
function util.count( t )
	local i = 0
	for _,_ in pairs( t ) do
		i = i + 1
	end
	return i
end

-- size based on the raw count
-- @provenance variant of 'function _.size(...)' from "Moses"
-- @param optional [table|any] count entries if table, count all args otherwise
-- @return count of entries
function util.size( ... )
	local v = select( 1, ... )
	if v == nil then
		return 0
	elseif type( v ) == 'table' then
		return util.count( v )
	end
	return util.count( { ... } )
end

-- deep equal of two objects
-- @provenance variant of 'UnitTester:equals_deep(name, actual, expected, options)' from [[w:no:Module:UnitTests]]
-- @provenance variant of 'function _.isEqual(objA, objB, useMt)' from "Moses"
-- @param objA any type of object
-- @param objB any type of object
-- @param useMt boolean optional indicator for whether to include the meta table
-- @return boolean result of comparison
function util.deepEqual( objA, objB, useMt )
	local typeObjA = type( objA )
	local typeObjB = type( objB )

	if typeObjA ~= typeObjB then
		return false end
	if typeObjA ~= 'table' then
		return objA == objB
	end

	local mtA = getmetatable( objA )
	local mtB = getmetatable( objB )

	if useMt then
		if (mtA or mtB) and (mtA.__eq or mtB.__eq) then
			return mtA.__eq( objA, objB ) or mtB.__eq( objB, objA ) or ( objA==objB )
		end
	end

	if util.size( objA ) ~= util.size( objB ) then
		return false
	end

	for i,v1 in pairs( objA ) do
		local v2 = objB[i]
		-- test is partly inlined, differs from "Moses"
		if v2 == nil or not util.deepEqual( v1, v2, useMt ) then
			return false
		end
	end

	for i,_ in pairs( objB ) do
		local v = objA[i]
		-- test is inlined, differs from "Moses"
		if v == nil then
			return false
		end
	end

	return true
end

-- checks if a table contains the arg
-- @provenance variant of 'function _.contains(t, value)' from "Moses"
-- @param t table that is searched for the arg
-- @param arg any item to be searched for
-- @return boolean result of the operation
function util.contains( t, arg )
	-- inlined code from '_.toBoolean' and '_.detect' from "Moses"
	local cmp = ( type( arg ) == 'function' ) and arg or util.deepEqual
	for k,v in pairs( t ) do
		if cmp( v, arg ) then
			return k
		end
	end
	return false
end

-- return the export table
return util
