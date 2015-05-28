# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['expr', 'utils', 'errors'], (Expr, utils, errors) ->
	class VecN
		constructor: (@symbols...) ->
		
		abs2: -> @symbols.map((x) -> x + '**2').join(' + ')
		abs:  -> '(' + abs2() + ')**(1/2)'
		
		@dot: (lhs, rhs) ->
			errors.TypeError.assert(lhs, VecN)
			errors.TypeError.assert(rhs, VecN)
			utils.zipWith(((l, r) -> l + '*' + r), lhs.symbols, rhs.symbols).join(' + ')
		
		dot: (other) -> @constructor.dot(this, other)
		
		isUnit: -> Expr.parse(@abs2() + ' = 1')
		isOrthogonalTo: (other) -> Expr.parse(@dot(other) + ' = 0')
	
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
