({
	baseUrl: 'src',
	paths: {
		coffeequate: '../build/lib/coffeequate',
		main: 'main'
	},
	name: 'main',
	out: 'build/openjscad-solve.min.js',
	onModuleBundleComplete: function (data) {
		var fs       = module.require('fs');
		var amdclean = module.require('amdclean');
		fs.writeFileSync(data.path, amdclean.clean({
			filePath: data.path,
			prefixMode: 'camelCase',
			prefixTransform: function (name, _) {
				return 'module_solve_' + name;
			},
			wrap: {
				start:
					'(function (root, solve) {\n'+
					'  root.solve = solve;\n'+
					'})(typeof global === \'object\' ? global : this, function() {\n',
				end: '\n'+
					'return module_solve_main;\n'+
					'}());\n'
			}
		}));
	}
})

