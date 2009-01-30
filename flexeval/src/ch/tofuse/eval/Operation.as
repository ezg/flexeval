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
package ch.tofuse.eval {
	
	public class Operation
	{
		private var type:Type;
		private var operator:Operator;
		private var operand1:Object;
		private var operand2:Object;
		private var operand3:Object;
	
		public function Operation(type:Type, operator:Operator, operand1:Object,
				operand2:Object, operand3:Object)
		{
			this.type = type;
			this.operator = operator;
			this.operand1 = operand1;
			this.operand2 = operand2;
			this.operand3 = operand3;
		}
	
		public static function nopOperationfactory(operand:Object):Operation
		{
			return new Operation(Operator.NOP().resultType, Operator.NOP(), operand,
					null, null);
		}
	
		public static function unaryOperationfactory(operator:Operator, operand:Object):Object
		{
			validateOperandType(operand, operator.operandType);
	
			/*
			 * If values can already be resolved then return result instead of
			 * operation
			 */
			if (operand is Number)
			{
				return operator.perform(operand as Number, null, null);
			}
			return new Operation(operator.resultType, operator, operand, null, null);
		}
	
		public static function binaryOperationfactory(operator:Operator, operand1:Object,
				operand2:Object):Object
		{
			validateOperandType(operand1, operator.operandType);
			validateOperandType(operand2, operator.operandType);
	
			/*
			 * If values can already be resolved then return result instead of
			 * operation
			 */
			if (operand1 is Number && operand2 is Number)
			{
				return operator.perform(operand1 as Number,
						operand2 as Number, null);
			}
			return new Operation(operator.resultType, operator, operand1, operand2,
					null);
		}
	
		public static function tenaryOperationFactory(operator:Operator, operand1:Object,
				operand2:Object, operand3:Object):Object
		{
			validateOperandType(operand1, Type.BOOLEAN);
			validateOperandType(operand2, Type.ARITHMETIC);
			validateOperandType(operand3, Type.ARITHMETIC);
	
			/*
			 * If values can already be resolved then return result instead of
			 * operation
			 */
			if (operand1 is Number)
			{
				return Functions.signum((operand1 as Number)) != 0 ? operand2 : operand3;
			}
			return new Operation(Type.ARITHMETIC, operator, operand1, operand2,
					operand3);
		}
	
		public function eval(variables:Array):Number
		{
			switch (this.operator.numberOfOperands)
			{
				case 3:
					return this.operator.perform(evaluateOperand(this.operand1,
							variables), evaluateOperand(this.operand2, variables),
							evaluateOperand(this.operand3, variables));
				case 2:
					return this.operator.perform(evaluateOperand(this.operand1,
							variables), evaluateOperand(this.operand2, variables),
							null);
				default:
					return this.operator.perform(evaluateOperand(this.operand1,
							variables), null, null);
			}
		}
	
		private function evaluateOperand(operand:Object,
				variables:Array):Number
		{
			if (operand is Operation)
			{
				return (operand as Operation).eval(variables);
			}
			else if (operand is String)
			{
				if (variables == null) {
					throw new Error("no variables defined");
				}
				var value:Number = 0;
				try {
					 value = variables[operand] as Number;
				}
				catch (e:Error) {
					throw new Error("no value for variable \"" + operand
							+ "\"");
				}
				return value;
			}
			else
			{
				return operand as Number;
			}
		}
	
		/**
		 * Validate that where operations are combined together that the types are
		 * as expected.
		 */
		private static function validateOperandType(operand:Object, type:Type):void
		{
			var operandType:Type;
	
			if (operand is Operation
					&& (operandType = (operand as Operation).type) != type)
			{
				throw new Error("cannot use " + operandType.name
						+ " operands with " + type.name + " operators");
			}
		}
	
		public function toString():String
		{
			switch (this.operator.numberOfOperands)
			{
				case 3:
					return "(" + this.operand1 + this.operator.string
							+ this.operand2 + ":" + this.operand3 + ")";
				case 2:
					return "(" + this.operand1 + this.operator.string
							+ this.operand2 + ")";
				default:
					return "(" + this.operator.string + this.operand1 + ")";
			}
		}
	}
}