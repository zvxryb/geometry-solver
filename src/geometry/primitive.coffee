define ->
	class Primitive
		constructor: (@elements) ->
		intrinsics: () -> @intrinsic().concat((p.intrinsics() for p in @elements)...)
		intrinsic: () -> []

