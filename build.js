({
	baseUrl: 'src',
	paths: {
		coffeequate: 'empty:',
		main: 'main'
	},
	name: 'main',
	out: 'geometrySolver.min.js',
	onModuleBundleComplete: function (data) {
		var fs       = module.require('fs');
		var amdclean = module.require('amdclean');
		fs.writeFileSync(data.path, amdclean.clean({
			filePath: data.path,
			prefixMode: 'camelCase',
			prefixTransform: function (name, _) {
				return 'geometrySolver_' + name;
			},
			wrap: {
				start:
					'(function (root, factory) {\n'+
					'  if (typeof define === \'function\' && define.amd)\n'+
					'    define([\'coffeequate\'], factory);\n'+
					'  else if (typeof module !== \'undefined\' && module.exports)\n'+
					'    module.exports = factory(require(\'coffeequate\'));\n'+
					'  else root.geometrySolver = factory(root.coffeequate);\n'+
					'})(this, function(geometrySolver_coffeequate) {\n',
				end: '\n'+
					'  return geometrySolver_main;\n'+
					'});\n'
			}
		}));
	}
})

