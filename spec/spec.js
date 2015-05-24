var solutionMatcher = function (util, eq) {
	var compare = function (lhs, rhs) {
		var lhs = lhs.slice().sort();
		var rhs = rhs.slice().sort();
		if (lhs.length != rhs.length) return false;
		var n = lhs.length;
		for (var i = 0; i < n; ++i)
			if (!util.equals(lhs[i], rhs[i], eq)) return false;
		return true;
	};

	return {
		compare: function (actual, expected) {
			var pass = compare(actual, expected);
			return {
				pass: pass,
				message: actual + (pass ? ' does ' : ' does not ') + 'have solutions ' + expected
			};
		}
	};
};

describe('triangle', function () {
	beforeEach(function() {
		jasmine.addMatchers({
			toHaveSolutions: solutionMatcher
		});
	});

	it('3, 4, 5', function () {
		var system = new global.solve.System();
		system.add('a**2 + b**2 = c**2');
		system.add('a = 3');
		system.add('c = 5');
		system.add('x0 = 0');
		system.add('y0 = 0');
		system.add('x1 = x0 + a');
		system.add('y1 = y0');
		system.add('x2 = x1');
		system.add('y2 = y0 + b');
		var a  = system.solve('a');
		var b  = system.solve('b');
		var c  = system.solve('c');
		var x0 = system.solve('x0');
		var y0 = system.solve('y0');
		var x1 = system.solve('x1');
		var y1 = system.solve('y1');
		var x2 = system.solve('x2');
		var y2 = system.solve('y2');
		expect(a ).toHaveSolutions([3]);
		expect(b ).toHaveSolutions([4, -4]);
		expect(c ).toHaveSolutions([5]);
		expect(x0).toHaveSolutions([0]);
		expect(y0).toHaveSolutions([0]);
		expect(x1).toHaveSolutions([3]);
		expect(y1).toHaveSolutions([0]);
		expect(x2).toHaveSolutions([3]);
		expect(y2).toHaveSolutions([4, -4]);
	});
});

