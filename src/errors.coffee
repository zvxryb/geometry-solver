# copyright 2015 by mike lodato (zvxryb@gmail.com)
# this work is subject to the terms of the MIT license

define ->
	class TypeError
		constructor: (actual, expected) ->
			@name    = @constructor.name
			@message = 'type ' + actual + ', expected ' + expected
			@stack   = (new Error).stack
		
		@assert: (value, type) ->
			args = switch typeof type
				when 'string'
					[typeof value, type] unless typeof value is type
				when 'function'
					[value.constructor.name, type.name] unless value instanceof type
				else undefined
			throw new TypeError(args...) if args
	
	(
		TypeError: TypeError
	)
