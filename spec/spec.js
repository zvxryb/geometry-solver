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

var exprMatcher = function (util, eq) {
	return {
		compare: function (actual, expected) {
			var pass = actual.cq.equals(expected.cq);
			return {
				pass: pass,
				message: actual.cq.toString() + (pass ? ' equals ' : ' does not equal ') + expected.cq.toString()
			}
		}
	}
}

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

describe('constraints', function () {
	beforeEach(function() {
		jasmine.addMatchers({
			toEqualExpr: exprMatcher
		});
	});

	it('scalar', function () {
		var Expr   = global.solve.Expr;
		var Scalar = global.solve.Scalar;
		var a = new Scalar('a');
		var b = new Scalar('b');
		var actual   = a.isEqualTo(b);
		var expected = Expr.parse('a = b');
		expect(actual).toEqualExpr(expected);
	});

	it('vector', function () {
		var Expr = global.solve.Expr;
		var Vec2 = global.solve.Vector.Vec2;
		var Vec3 = global.solve.Vector.Vec3;
		var a = new Vec2('a');
		var b = new Vec2('b');
		var c = new Vec3('c');
		var d = new Vec3('d');
		expect(a.isUnit()).toEqualExpr(Expr.parse('a_x**2 + a_y**2 = 1'))
		expect(a.isOrthogonalTo(b)).toEqualExpr(Expr.parse('a_x*b_x + a_y*b_y = 0'))
		expect(c.isUnit()).toEqualExpr(Expr.parse('c_x**2 + c_y**2 + c_z**2 = 1'))
		expect(c.isOrthogonalTo(d)).toEqualExpr(Expr.parse('c_x*d_x + c_y*d_y + c_z*d_z = 0'))
	});
	
	it('line', function () {
		var Expr = global.solve.Expr;
		var Vec2 = global.solve.Vector.Vec2;
		var Line = global.solve.Line;
		
		var a = new Vec2('a');
		var b = new Vec2('b');
		var line = new Line('line', Vec2);
		
		var intrinsics = line.intrinsics();
		expect(intrinsics.length).toBe(1);
		expect(intrinsics[0]).toEqualExpr(Expr.parse('line_dir_x**2 + line_dir_y**2 = 1'));
		
		(function (x, y) {
			expect(x).toEqualExpr(Expr.parse('line_orig_x = a_x'));
			expect(y).toEqualExpr(Expr.parse('line_orig_y = a_y'));
		}).apply(this, line.orig.isEqualTo(a));
		
		(function (x, y) {
			expect(x).toEqualExpr(Expr.parse('line_orig_x + line_temp0 * line_dir_x = b_x'))
			expect(y).toEqualExpr(Expr.parse('line_orig_y + line_temp0 * line_dir_y = b_y'))
		}).apply(this, line.isIncident(b));
	});
});

