---@class ComplexNumber
---@field real number
---@field imaginary number
---@operator add(ComplexNumber|number): ComplexNumber
---@operator sub(ComplexNumber|number): ComplexNumber
---@operator mul(ComplexNumber|number): ComplexNumber
---@operator div(ComplexNumber|number): ComplexNumber
---@operator unm: ComplexNumber
---@operator call: ComplexNumber

local complex_metatable = {}

--- I can't explain this voodoo very well, so I won't explain it.
---@param op1 ComplexNumber|number
---@param op2 ComplexNumber|number
---@return ComplexNumber
function complex_metatable.__add(op1, op2)
    if type(op1) == "number" then
        op1 = CreateComplexNum(op1)
    end
    if type(op2) == "number" then
        op2 = CreateComplexNum(op2)
    end

    if type(op1) ~= "table" then
        error()
    end
    if type(op1.real) ~= "number" then
        error()
    end
    if type(op1.imaginary) ~= "number" then
        error()
    end

    if type(op2) ~= "table" then
        error()
    end
    if type(op2.real) ~= "number" then
        error()
    end
    if type(op2.imaginary) ~= "number" then
        error()
    end

    return CreateComplexNum(op1.real + op2.real, op1.imaginary + op2.imaginary)
end

--- I can't explain this voodoo very well, so I won't explain it.
---@param op1 ComplexNumber|number
---@param op2 ComplexNumber|number
---@return ComplexNumber
function complex_metatable.__sub(op1, op2)
    if type(op1) == "number" then
        op1 = CreateComplexNum(op1)
    end
    if type(op2) == "number" then
        op2 = CreateComplexNum(op2)
    end

    if type(op1) ~= "table" then
        error()
    end
    if type(op1.real) ~= "number" then
        error()
    end
    if type(op1.imaginary) ~= "number" then
        error()
    end

    if type(op2) ~= "table" then
        error()
    end
    if type(op2.real) ~= "number" then
        error()
    end
    if type(op2.imaginary) ~= "number" then
        error()
    end

    return CreateComplexNum(op1.real - op2.real, op1.imaginary - op2.imaginary)
end

--- I can't explain this voodoo very well, so I won't explain it.
---@param op1 ComplexNumber|number
---@param op2 ComplexNumber|number
---@return ComplexNumber
function complex_metatable.__mul(op1, op2)
    if type(op1) == "number" then
        op1 = CreateComplexNum(op1)
    end
    if type(op2) == "number" then
        op2 = CreateComplexNum(op2)
    end

    if type(op1) ~= "table" then
        error()
    end
    if type(op1.real) ~= "number" then
        error()
    end
    if type(op1.imaginary) ~= "number" then
        error()
    end

    if type(op2) ~= "table" then
        error()
    end
    if type(op2.real) ~= "number" then
        error()
    end
    if type(op2.imaginary) ~= "number" then
        error()
    end

    local new_real = op1.real * op2.real - op1.imaginary * op2.imaginary
    local new_imaginary = op1.real * op2.imaginary + op1.imaginary * op2.real

    return CreateComplexNum(new_real, new_imaginary)
end

--- This function is literal voodoo idk what's even going on here
---@param op1 ComplexNumber|number
---@param op2 ComplexNumber|number
---@return ComplexNumber
function complex_metatable.__div(op1, op2)
    if type(op1) == "number" then
        op1 = CreateComplexNum(op1)
    end
    if type(op2) == "number" then
        op2 = CreateComplexNum(op2)
    end

    if type(op1) ~= "table" then
        error()
    end
    if type(op1.real) ~= "number" then
        error()
    end
    if type(op1.imaginary) ~= "number" then
        error()
    end

    if type(op2) ~= "table" then
        error()
    end
    if type(op2.real) ~= "number" then
        error()
    end
    if type(op2.imaginary) ~= "number" then
        error()
    end

    local new_real = (op1.real * op2.real + op1.imaginary * op2.imaginary) / (op1.imaginary * op1.imaginary + op2.imaginary * op2.imaginary)
    local new_imaginary = (op1.imaginary * op2.real - op1.real * op2.imaginary) / (op1.imaginary * op1.imaginary + op2.imaginary * op2.imaginary)

    return CreateComplexNum(new_real, new_imaginary)
end

--- Something slightly simpler
---@param op ComplexNumber
---@return ComplexNumber
function complex_metatable.__unm(op)
    if type(op) == "number" then
        op = CreateComplexNum(op)
    end

    if type(op) ~= "table" then
        error()
    end
    if type(op.real) ~= "number" then
        error()
    end
    if type(op.imaginary) ~= "number" then
        error()
    end

    return CreateComplexNum(-op.real, -op.imaginary)
end

--- This function is less complex voodoo (pun intended)
---@param op1 ComplexNumber|number
---@param op2 ComplexNumber|number
---@return boolean
function complex_metatable.__eq(op1, op2)
    if type(op1) == "number" then
        op1 = CreateComplexNum(op1)
    end
    if type(op2) == "number" then
        op2 = CreateComplexNum(op2)
    end

    if type(op1) ~= type(op2) then
        return false
    end

    if type(op1) ~= "table" then
        error()
    end
    if type(op1.real) ~= "number" then
        return false
    end
    if type(op1.imaginary) ~= "number" then
        return false
    end

    if type(op2) ~= "table" then
        error()
    end
    if type(op2.real) ~= "number" then
        return false
    end
    if type(op2.imaginary) ~= "number" then
        return false
    end

    return op1.real == op2.real and op1.imaginary == op2.imaginary
end

--- Only checks the real part of the number, keep that in mind.
---@param op1 ComplexNumber|number
---@param op2 ComplexNumber|number
---@return boolean
function complex_metatable.__lt(op1, op2)
    if type(op1) == "number" then
        op1 = CreateComplexNum(op1)
    end
    if type(op2) == "number" then
        op2 = CreateComplexNum(op2)
    end

    if type(op1) ~= "table" then
        error()
    end
    if type(op1.real) ~= "number" then
        error()
    end
    if type(op1.imaginary) ~= "number" then
        error()
    end

    if type(op2) ~= "table" then
        error()
    end
    if type(op2.real) ~= "number" then
        error()
    end
    if type(op2.imaginary) ~= "number" then
        error()
    end

    return op1.real < op2.real
end

--- Only checks the real part of the number, keep that in mind.
---@param op1 ComplexNumber|number
---@param op2 ComplexNumber|number
---@return boolean
function complex_metatable.__le(op1, op2)
    if type(op1) == "number" then
        op1 = CreateComplexNum(op1)
    end
    if type(op2) == "number" then
        op2 = CreateComplexNum(op2)
    end

    if type(op1) ~= "table" then
        error()
    end
    if type(op1.real) ~= "number" then
        error()
    end
    if type(op1.imaginary) ~= "number" then
        error()
    end

    if type(op2) ~= "table" then
        error()
    end
    if type(op2.real) ~= "number" then
        error()
    end
    if type(op2.imaginary) ~= "number" then
        error()
    end

    return op1.real <= op2.real
end

--- Create a copy of this complex number.
---@param self ComplexNumber
---@return ComplexNumber
function complex_metatable:__call()
    return CreateComplexNum(self.real, self.imaginary)
end

--- The tostring function. What did you expect, the entire language to become a string or something?
---@param self ComplexNumber
---@return string
function complex_metatable:__tostring()
    return tostring(self.real) .. " + " .. tostring(self.imaginary) .. "i"
end

--- Creates a complex number from one or two real numbers, using one as the real part, and the other as the imaginary part.
---@param real number? The real part of the complex number.
---@param imaginary number? The imaginary part of the complex number.
---@return ComplexNumber
---@nodiscard
function CreateComplexNum(real, imaginary)
    local complex_num = {real = real or 0, imaginary = imaginary or 0}

    setmetatable(complex_num, complex_metatable)

    return complex_num
end