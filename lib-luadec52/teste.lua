
local lib = require "luadec"

function  wrap( code )
    return "return " .. code
end

describe("Binary Expression Tests" , function ()
  


  describe("Arith exp" , function ()
    
    it("Bin op + ", function  ()
       foo = function (x) return x + x end
       local code = lib.luadec(foo)
       assert.True( foo(2) == assert(loadstring(wrap(code)))() (2) )
    end)

    it("Bin op - ", function  ()
       foo = function (x) return x - x end
       local code = lib.luadec(foo)
       assert.True( foo(2) == assert(loadstring(wrap(code)))() (2) )
    end)

    it("Bin op * ", function  ()
       foo = function (x) return x * x end
       local code = lib.luadec(foo)
       assert.True( foo(2) == assert(loadstring(wrap(code)))() (2) )
    end)

    it("Bin op / ", function  ()
       foo = function (x) return x / x end
       local code = lib.luadec(foo)
       assert.True( foo(2) == assert(loadstring(wrap(code)))() (2) )
    end)

    it("Bin op % ", function  ()
       foo = function (x) return x % x end
       local code = lib.luadec(foo)
      assert.True( foo(2) == assert(loadstring(wrap(code)))() (2) )
    end)

    it("Bin op ^ ", function  ()
       foo = function (x) return x ^ x end
       local code = lib.luadec(foo)
      assert.True( foo(2) == assert(loadstring(wrap(code)))() (2) )
    end)
  end)

  describe("Relational exp" , function ()
      it("Bin op > ", function  ()
        foo = function (x) return x > x end
        local code = lib.luadec(foo)
        assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
      end)
      it("Bin op < ", function  ()
        foo = function (x) return x < x end
        local code = lib.luadec(foo)
        assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
      end)
      it("Bin op <= ", function  ()
        foo = function (x) return x <= x end
        local code = lib.luadec(foo)
        assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
      end)
      it("Bin op >= ", function  ()
        foo = function (x) return x >= x end
        local code = lib.luadec(foo)
        assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
      end)
      it("Bin op == ", function  ()
        foo = function (x) return x == x end
        local code = lib.luadec(foo)
        assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
      end)
      it("Bin op ~= ", function  ()
        foo = function (x) return x ~= x end
        local code = lib.luadec(foo)
        assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
      end)
  end)
 
  describe("Logical exp" , function ()
      it("Bin op and ", function  ()
        foo = function (x) return x and x end
        local code = lib.luadec(foo)
        print(code)
        assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
      end)
      it("Bin op or ", function  ()
        foo = function (x) return x or x end
        local code = lib.luadec(foo)
       -- print(code)

        assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
      end)
  end)

  it("Bin op .. ", function  ()
     foo = function (x) return x .. x end
     local code = lib.luadec(foo)
    assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
  end)
end)

describe("Unary Expression Tests", function () 
   
  describe("Arith exp" , function ()
    
    it("Unary op - ", function  ()
       foo = function (x) return -x  end
       local code = lib.luadec(foo)
       assert.True( foo(2) == assert(loadstring(wrap(code)))() (2) )
    end)
  end)

  describe("Logical exp" , function ()
    it("Bin op not ", function  ()
      foo = function (x) return not x end
      local code = lib.luadec(foo)
      assert.True( foo(2) == assert(loadstring(wrap(code)) )() (2) )
    end)
  end)

  it("Unary op # ", function  ()
    foo = function (x) return #x end
    local code = lib.luadec(foo)
    assert.True( foo("lol") == assert(loadstring(wrap(code)) )() ("lol") )
  end)


-- describe("Table Constructors",function ()
--   it("Simple return ", function  ()
--     foo = function (x) return { a = x } end
--     local code = lib.luadec(foo)
    
--     assert.True( foo(2).a == assert(loadstring(wrap(code)))()(2).a )
--   end)
-- end)

end)