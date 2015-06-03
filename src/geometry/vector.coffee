# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['math/expr', 'geometry/primitive', 'geometry/scalar', 'core/utils', 'core/errors'], (Expr, Primitive, Scalar, utils, errors) ->
	class VecN extends Primitive
		constructor: (@vars...) ->
			errors.TypeError.assert(x, Expr) for x in @vars
			super()
		
		abs2: -> Expr.add((x.pow(Expr.const(2)) for x in @vars)...)
		abs:  -> abs2().pow(Expr.const(1, 2))
		
		scale: (other) ->
			expr = switch
				when other instanceof Expr   then other
				when other instanceof Scalar then other.var
				else throw new errors.TypeError.throw(other, Expr, Scalar)
			new VecN((expr.mul(x) for x in @vars)...)
		
		@add: (lhs, rhs) ->
			errors.TypeError.assert(lhs, VecN)
			errors.TypeError.assert(rhs, VecN)
			new VecN(utils.zipWith(Expr.add, lhs.vars, rhs.vars)...)
		
		add: (other) -> @constructor.add(this, other)
		
		@dot: (lhs, rhs) ->
			errors.TypeError.assert(lhs, VecN)
			errors.TypeError.assert(rhs, VecN)
			Expr.add(utils.zipWith(Expr.mul, lhs.vars, rhs.vars)...)
		
		dot: (other) -> @constructor.dot(this, other)
		
		isUnit: -> @abs2().eq(Expr.const(1))
		isOrthogonalTo: (other) -> @dot(other)
		isEqualTo: (other) -> utils.zipWith(Expr.eq, @vars, other.vars)
	
	class Vec2 extends VecN
		constructor: (prefix) ->
			[@x, @y] = Expr.vars(prefix, 'x', 'y')
			super(@x, @y)
	
	class Vec3 extends VecN
		constructor: (prefix) ->
			[@x, @y, @z] = Expr.vars(prefix, 'x', 'y', 'z')
			super(@x, @y, @z)
	
	(
		VecN: VecN
		Vec2: Vec2
		Vec3: Vec3
	)

