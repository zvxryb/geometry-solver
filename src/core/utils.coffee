# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ->
	zipWith: (f, lhs, rhs) ->
		throw 'vector length mismatch' unless lhs.length == rhs.length
		n = lhs.length
		(f(lhs[i], rhs[i]) for i in [0...n])
