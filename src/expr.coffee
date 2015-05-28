# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['coffeequate'], (CQ) ->
	class Expr
		constructor: (@cq) ->
			throw 'undefined expression' unless @cq?
			@vars = @cq.getAllVariables?().sort() ? []

		@parse: (s) -> new Expr(CQ(s))

		solve: (x) -> (new Expr(y) for y in @cq.solve(x))

		sub: (x) ->
			y = {}
			for [k, v] in x
				y[k] = v.cq
			new Expr(@cq.sub(y))

		approx: -> @cq.approx()

		toString: -> @cq.toString()

		has: (x) ->
			for y in @vars
				return true if x is y
			false

		@common: (lhs, rhs) ->
			i = 0
			j = 0
			common = []
			while i < lhs.vars.length and j < rhs.vars.length
				x = lhs.vars[i]
				y = rhs.vars[j]
				if      x < y then i++
				else if x > y then j++
				else
					common.push(x)
					i++
					j++
			return common

		common: (other) -> @constructor.common(this, other)

	Expr

