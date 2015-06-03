# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['math/expr', 'geometry/primitive', 'core/errors'], (Expr, Primitive, errors) ->
	class Scalar extends Primitive
		constructor: (symbol) ->
			@var = Expr.var(symbol)
			super()

		isEqualTo: (other) ->
			errors.TypeError.assert(other, Scalar)
			return @var.eq(other.var)

