# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['math/expr', 'core/utils', 'core/errors'], (Expr, utils, errors) ->
	class VecN
		constructor: (@symbols...) ->
		
		abs2: -> Expr.add((Expr.var(x).pow(Expr.const(2)) for x in @symbols)...)
		abs:  -> abs2().pow(Expr.const(1, 2))
		
		@dot: (lhs, rhs) ->
			errors.TypeError.assert(lhs, VecN)
			errors.TypeError.assert(rhs, VecN)
			Expr.add(utils.zipWith((x, y) ->
				Expr.var(x).mul(Expr.var(y))
			, lhs.symbols, rhs.symbols)...)
		
		dot: (other) -> @constructor.dot(this, other)
		
		isUnit: -> @abs2().eq(Expr.const(1))
		isOrthogonalTo: (other) -> @dot(other)
	
	class Vec2 extends VecN
		constructor: (prefix) ->
			@x = prefix + '_x'
			@y = prefix + '_y'
			super(@x, @y)
	
	class Vec3 extends VecN
		constructor: (prefix) ->
			@x = prefix + '_x'
			@y = prefix + '_y'
			@z = prefix + '_z'
			super(@x, @y, @z)
	
	(
		Vec2: Vec2
		Vec3: Vec3
	)
