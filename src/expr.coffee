# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['coffeequate', 'errors'], (CQ, errors) ->
	class Expr
		constructor: (@cq) ->
			throw 'undefined expression' unless @cq?
			@vars = @cq.getAllVariables?().sort() ? []

		@parse: (s) -> new Expr(CQ(s))

		@var: (label) ->
			errors.TypeError.assert(label, 'string')
			new Expr(CQ(new CQ.raw.Variable(label)))

		@const: (args...) ->
			new Expr(CQ(new CQ.raw.Constant(args...)))

		@add: (terms...) ->
			cq = ((errors.TypeError.assert(term, Expr); term.cq.expr) for term in terms)
			new Expr(CQ(new CQ.raw.Add(cq...)))

		@mul: (terms...) ->
			cq = ((errors.TypeError.assert(term, Expr); term.cq.expr) for term in terms)
			new Expr(CQ(new CQ.raw.Mul(cq...)))

		@pow: (x, y) ->
			errors.TypeError.assert(x, Expr)
			errors.TypeError.assert(y, Expr)
			new Expr(CQ(new CQ.raw.Pow(x.cq.expr, y.cq.expr)))

		@eq: (x, y) ->
			errors.TypeError.assert(x, Expr)
			errors.TypeError.assert(y, Expr)
			@add(@mul(@const(-1), x), y)

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

		add: (other) -> @constructor.add(this, other)
		mul: (other) -> @constructor.mul(this, other)
		pow: (other) -> @constructor.pow(this, other)
		eq:  (other) -> @constructor.eq(this, other)

		common: (other) -> @constructor.common(this, other)

	Expr

