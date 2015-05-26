# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['coffeequate'], (CQ) ->
	class SolveError extends Error
		constructor: (@message, @cause) ->
			@stack = @cause?.stack
	
	class OverdeterminedError extends SolveError
		constructor: ->
			super('overdetermined', null)
	
	class UnderdeterminedError extends SolveError
		constructor: ->
			super('underdetermined', null)

	class Expr
		constructor: (@cq) ->
			throw 'undefined expression' unless @cq?
			@vars = @cq.getAllVariables?().sort() ? []

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

	unique = (array) ->
		return array.slice().sort().filter((y) ->
			isUnique = y isnt @last
			@last = y
			return isUnique
		, {last: null})

	class System
		constructor: -> @exprList = []
		
		add: (s) -> @exprList.push(new Expr(CQ(s)))
		
		vars: ->
			vars = []
			vars.push(expr.vars...) for expr in @exprList
			return unique(vars)
		
		@solve: (x, expr, exprList) ->
			if expr.vars.length is 1 and expr.vars[0] is x
				return (y.approx() for y in expr.solve(x))
			for e0 in exprList
				common = expr.common(e0)
				continue unless common.length > 0
				for y in common
					continue if y is x
					results = []
					for e1 in e0.solve(y)
						results.push(@solve(x,
							expr.sub([[y, e1]]),
							exprList.filter((e2) -> e2 isnt e0))...)
					return results if results.length > 0
			return []
		
		solve: (x) ->
			vars = @vars()
			n = vars.length
			throw new UnderdeterminedError() if @exprList.length < n
			throw new OverdeterminedError()  if @exprList.length > n
			
			results = []
			for expr in @exprList
				continue unless expr.has(x)
				remaining = @exprList.filter((e) -> e isnt expr)
				results.push(@constructor.solve(x, expr, remaining)...)
			return unique(results)

	System

