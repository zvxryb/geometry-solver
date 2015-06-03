# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ['core/utils', 'core/errors', 'math/expr', 'geometry/primitive', 'geometry/vector'],
	(utils, errors, Expr, Primitive, Vector) ->
		class Line extends Primitive
			constructor: (prefix, Vec) ->
				@orig = new Vec(prefix + '_orig')
				@dir  = new Vec(prefix + '_dir')
				errors.TypeError.assert(@orig, Vector.VecN)
				errors.TypeError.assert(@dir,  Vector.VecN)
				super(@orig, @dir)
				
				@tempVar = (() ->
					idx = 0
					() -> Expr.var(prefix + '_temp' + idx++)
				)()
		
			intrinsic: () -> [ @dir.isUnit() ]
		
			isIncident: (other) ->
				errors.TypeError.assert(other, Primitive)
				switch
					when other instanceof Vector.VecN
						@orig.add(@dir.scale(@tempVar())).isEqualTo(other)
					else undefined
		
		Line

