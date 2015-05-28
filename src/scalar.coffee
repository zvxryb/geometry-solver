# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['expr', 'errors'], (Expr, errors) ->
	class Scalar
		constructor: (@symbol) ->

		isEqualTo: (other) ->
			errors.TypeError.assert(other, Scalar)
			return Expr.parse(@symbol + ' = ' + other.symbol)

