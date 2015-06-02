# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['math/expr', 'core/errors'], (Expr, errors) ->
	class Scalar
		constructor: (@symbol) ->

		isEqualTo: (other) ->
			errors.TypeError.assert(other, Scalar)
			return Expr.var(@symbol).eq(Expr.var(other.symbol))

