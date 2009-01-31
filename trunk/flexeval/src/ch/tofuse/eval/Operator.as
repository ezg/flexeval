/*
 * Copyright 2008  Reg Whitton
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ch.tofuse.eval 
{
	public class Operator
	{
		public var precedence:int;
		public var numberOfOperands:int;
		public var string:String;
		public var resultType:Type;
		public var operandType:Type;
	
		public function Operator(precedence:int, numberOfOperands:int,
				string:String, resultType:Type, operandType:Type)
		{ 
			this.precedence = precedence;
			this.numberOfOperands = numberOfOperands;
			this.string = string;
			this.resultType = resultType;
			this.operandType = operandType;
		}
	
		public function perform(value1:Number, value2:Number,
				value3:Number):Number {
			return NaN;
		}
		
		private static var end:ENDOperator = null;
		public static function END():Operator {
			if (end == null) {
				end = new ENDOperator(-1, 0, null, null, null);
			}
			return end;
		}
		private static var ternary:Operator = null;
		public static function TERNARY():Operator {
			if (ternary == null) {
				ternary = new TERNARYOperator(0, 3, "?", null, null);
			}
			return ternary;
		}
		private static var and:Operator = null;
		public static function AND():Operator {
			if (and == null) {
				and = new new ANDOperator(0, 2, "&&", Type.BOOLEAN, Type.BOOLEAN);
			}
			return and;
		}
		private static var or:Operator = null;
		public static function OR():Operator {
			if (or == null) {
				or = new OROperator(0, 2, "||", Type.BOOLEAN, Type.BOOLEAN);
			}
			return or;
		}
		private static var gt:Operator = null;
		public static function GT():Operator {
			if (gt == null) {
				gt = new GTOperator(1, 2, ">", Type.BOOLEAN, Type.ARITHMETIC);
			}
			return gt;
		}
		private static var ge:Operator = null;
		public static function GE():Operator {
			if (ge == null) {
				ge = new GEOperator(1, 2, ">=", Type.BOOLEAN, Type.ARITHMETIC);
			}
			return ge;
		}
		private static var lt:Operator = null;
		public static function LT():Operator {
			if (lt == null) {
				lt = new LTOperator(1, 2, "<", Type.BOOLEAN, Type.ARITHMETIC);
			}
			return lt;
		}
		private static var le:Operator = null;
		public static function LE():Operator {
			if (le == null) {
				le = new LEOperator(1, 2, "<=", Type.BOOLEAN, Type.ARITHMETIC);
			}
			return le;
		}
		private static var eq:Operator = null;
		public static function EQ():Operator {
			if (eq == null) {
				eq = new EQOperator(1, 2, "==", Type.BOOLEAN, Type.ARITHMETIC);
			}
			return eq;
		}
		private static var ne:Operator = null;
		public static function NE():Operator {
			if (ne == null) {
				ne = new NEOperator(1, 2, "!=", Type.BOOLEAN, Type.ARITHMETIC);
			}
			return ne;
		}
		private static var add:Operator = null;
		public static function ADD():Operator {
			if (add == null) {
				add = new ADDOperator(2, 2, "+", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return add;
		}
		private static var sub:Operator = null;
		public static function SUB():Operator {
			if (sub == null) {
				sub = new SUBOperator(2, 2, "-", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return sub;
		}
		private static var div:Operator = null;
		public static function DIV():Operator {
			if (div == null) {
				div = new DIVOperator(3, 2, "/", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return div;
		}
		private static var remainder:Operator = null;
		public static function REMAINDER():Operator {
			if (remainder == null) {
				remainder = new REMAINDEROperator(3, 2, "%", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return remainder;
		}
		private static var mul:Operator = null;
		public static function MUL():Operator {
			if (mul == null) {
				mul = new MULOperator(3, 2, "*", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return mul;
		}
		private static var neg:Operator = null;
		public static function NEG():Operator {
			if (neg == null) {
				neg = new NEGOperator(4, 1, "-", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return neg;
		}
		private static var plus:Operator =  null;
		public static function PLUS():Operator {
			if (plus == null) {
				plus = new PLUSOperator(4, 1, "+", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return plus;
		}
		private static var abs:Operator = null;
		public static function ABS():Operator {
			if (abs == null) {
				abs = new ABSOperator(4, 1, " abs ", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return abs;
		}
		private static var pow:Operator = null;
		public static function POW():Operator {
			if (pow == null) {
				pow = new POWOperator(4, 2, " pow ", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return pow;
		}
		private static var intOp:Operator = null;
		public static function INT():Operator {
			if (intOp == null) {
				intOp = new INTOperator(4, 1, "int ", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return intOp;
		}
		private static var nop:Operator = null;
		public static function NOP():Operator {
			if (nop == null) {
				nop = new NOPOperator(4, 1, "", Type.ARITHMETIC, Type.ARITHMETIC);
			}
			return nop;
		}
	}
}
	import ch.tofuse.eval.Functions;
	import ch.tofuse.eval.Operator;
	import ch.tofuse.eval.Type;
	


/**
 * End of string reached.
 */
class ENDOperator extends Operator
{
	public function ENDOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		throw new Error("END is a dummy operation");
	}
}

/**
 * condition ? (expression if true) : (expression if false)
 */
class TERNARYOperator extends Operator
{
	public function TERNARYOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return (Functions.signum(value1) != 0) ? value2 : value3;
	}
}

/**
 * &amp;&amp;
 */
class ANDOperator extends Operator
{
	public function ANDOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Functions.signum(value1) != 0 && Functions.signum(value2) != 0 ? 1 : 0;
	}
}

/**
 * ||
 */
class OROperator extends Operator
{
	public function OROperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Functions.signum(value1) != 0 || Functions.signum(value2) != 0 ? 1
				: 0;
	}
}

/**
 * &gt;
 */
class GTOperator extends Operator
{
	public function GTOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Functions.compareTo(value1, value2) > 0 ? 1
				: 0;
	}
}

/**
 * &gt;=
 */
class GEOperator extends Operator
{
	public function GEOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Functions.compareTo(value1, value2) >= 0 ? 1
				: 0;
	}
}

/**
 * &lt;
 */
class LTOperator extends Operator
{
	public function LTOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Functions.compareTo(value1, value2) < 0 ? 1
				: 0;
	}
}

/**
 * &lt;=
 */
class LEOperator extends Operator
{
	public function LEOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Functions.compareTo(value1, value2) <= 0 ? 1
				: 0;
	}
}

/**
 * ==
 */
class EQOperator extends Operator
{
	public function EQOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Functions.compareTo(value1, value2) == 0 ? 1
				: 0;
	}
}


/**
 * != or &lt;&gt;
 */
class NEOperator extends Operator
{
	public function NEOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Functions.compareTo(value1, value2) != 0 ? 1
				: 0;
	}
}

/**
 * +
 */
class ADDOperator extends Operator
{
	public function ADDOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return value1 + value2;
	}
}

/**
 * -
 */
class SUBOperator extends Operator
{
	public function SUBOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return value1 - value2;
	}
}
/**
 * /
 */
class DIVOperator extends Operator
{
	public function DIVOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return value1 / value2;
	}
}

/**
 * %
 */
class REMAINDEROperator extends Operator
{
	public function REMAINDEROperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return value1 % value2;
	}
}

/**
 * *
 */
class MULOperator extends Operator
{
	public function MULOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return value1 * value2;
	}
}

/**
 * -negate
 */
class NEGOperator extends Operator
{
	public function NEGOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return value1 * -1;
	}
}

/**
 * +plus
 */
class PLUSOperator extends Operator
{
	public function PLUSOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return value1;
	}
}

/**
 * abs
 */
class ABSOperator extends Operator
{
	public function ABSOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return Math.abs(value1);
	}
}

/**
 * pow
 */
class POWOperator extends Operator
{
	public function POWOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
				
		return Math.pow(value1, value2);
	}
}

/**
 * int
 */
class INTOperator extends Operator
{
	public function INTOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return parseInt(value1.toString());
	}
}

/**
 * No operation - used internally when expression contains only a reference
 * to a variable.
 */
class NOPOperator extends Operator
{
	public function NOPOperator(precedence:int, numberOfOperands:int,
			string:String, resultType:Type, operandType:Type)
	{
		super(precedence, numberOfOperands, string, resultType, operandType);
	}
	public override function perform(value1:Number, value2:Number,
			value3:Number):Number {
		return value1;
	}
}

