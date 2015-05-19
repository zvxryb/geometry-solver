({
	baseUrl: 'lib/Coffeequate/coffeequate/src',
	name: 'coffeequate',
	optimize: 'none',
	out: 'build/lib/coffeequate.js',
	onModuleBundleComplete: function (data) {
		var fs       = module.require('fs');
		var amdclean = module.require('amdclean');
		fs.writeFileSync(data.path, amdclean.clean({
			filePath: data.path,
			prefixMode: 'camelCase',
			prefixTransform: function (name, _) {
				return 'module_coffeequate_' + name;
			},
			wrap: {
				start: 'define(function () {\n',
				end: '\n'+
					'return module_coffeequate_coffeequate;\n'+
					'});\n'
			}
		}));
	}
})

