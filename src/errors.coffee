# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ->
	class TypeError extends Error
		constructor: (@actual, @expected) ->
			@message = 'type ' + @actual + ', expected ' + @expected
		
		@assert: (value, type) ->
			throw new TypeError(value.constructor.name, type.name) unless value instanceof type
	
	(
		TypeError: TypeError
	)
