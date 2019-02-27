local _class={}

function class(super)
	local class_type = { ctor = false, super = super }    -- 'ctor' field must be here
	local vtbl = {}
	_class[class_type] = vtbl
  
    -- class_type is one proxy indeed. (return class type, but operate vtbl)
	setmetatable(class_type, {
		__newindex= function(t,k,v) vtbl[k] = v end,			
		__index = function(t,k) return vtbl[k] end,
	})

    -- when first invoke the method belong to parent,retrun value of parent
    -- and set the value to child
	if super then
		setmetatable(vtbl, { __index=
			function(t, k)
                if k and _class[super] then
                    local ret = _class[super][k]
                    vtbl[k] = ret                      -- remove this if lua running on back-end server
                    return ret
                else return nil end
			end
		})
	end
    
    class_type.new = function(...)
        local obj = { class = class_type }
        setmetatable(obj, { __index = _class[class_type] })
        
        -- deal constructor recursively
        local inherit_list = {}
		local class_ptr = class_type
		while class_ptr do
			if class_ptr.ctor then table.insert(inherit_list, class_ptr) end
			class_ptr = class_ptr.super
		end
		local inherit_length = #inherit_list
		if inherit_length > 0 then
		    for i = inherit_length, 1, -1 do inherit_list[i].ctor(obj, ...) end
		end
        
        obj.class = class_type              -- must be here, because some class constructor change class property.

        return obj
    end
	
	class_type.is = function(self_ptr, compare_class)
		if not compare_class or not self_ptr then return false end
		local raw_class = self_ptr.class
		while raw_class do
			if raw_class == compare_class then return true end
			raw_class = raw_class.super
		end
		return false
	end
	
	return class_type
end
