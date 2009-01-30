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
	public class Compiler
	{
		private var tokeniser:Tokeniser;
	
		function Compiler(expression:String)
		{
			this.tokeniser = new Tokeniser(expression);
		}
	
		public function compile():Operation 
		{
			var expression:Object = compileRecursive(null, null, 0, String.fromCharCode(0), -1);
	
			/*
			 * If expression is a variable name or BigDecimal constant value then we
			 * need to put into a NOP operation.
			 */
			if (expression is Operation)
			{
				return Operation(expression);
			}
			return Operation.nopOperationfactory(expression);
		}
	
		private function compileRecursive(preReadOperand:Object, preReadOperator:Operator,
				nestingLevel:int, endOfExpressionChar:String, terminatePrecedence:int):Object
		{
			var operand:Object = preReadOperand != null ? preReadOperand
					: getOperand(nestingLevel);
			var operator:Operator = preReadOperator != null ? preReadOperator
					: this.tokeniser.getOperator(endOfExpressionChar);
	
			while (operator != Operator.END())
			{
				if (operator == Operator.TERNARY())
				{
					var operand2:Object = compileRecursive(null, null, nestingLevel, ':', -1);
					var operand3:Object = compileRecursive(null, null, nestingLevel,
							endOfExpressionChar, -1);
					operand = Operation.tenaryOperationFactory(operator, operand,
							operand2, operand3);
					operator = Operator.END();
				}
				else
				{
					var nextOperand:Object = getOperand(nestingLevel);
					var nextOperator:Operator = this.tokeniser
							.getOperator(endOfExpressionChar);
					if (nextOperator == Operator.END())
					{
						/* We are at the end of the expression */
						operand = Operation.binaryOperationfactory(operator,
								operand, nextOperand);
						operator = Operator.END();
					}
					else if (nextOperator.precedence <= terminatePrecedence)
					{
						/*
						 * The precedence of the following operator effectively
						 * brings this expression to an end.
						 */
						operand = Operation.binaryOperationfactory(operator,
								operand, nextOperand);
						this.tokeniser.pushBack(nextOperator);
						operator = Operator.END();
					}
					else if (operator.precedence >= nextOperator.precedence)
					{
						/* The current operator binds tighter than any following it */
						operand = Operation.binaryOperationfactory(operator,
								operand, nextOperand);
						operator = nextOperator;
					}
					else
					{
						/*
						 * The following operator binds tighter so compile the
						 * following expression first.
						 */
						operand = Operation.binaryOperationfactory(operator,
								operand, compileRecursive(nextOperand, nextOperator,
										nestingLevel, endOfExpressionChar,
										operator.precedence));
						operator = this.tokeniser.getOperator(endOfExpressionChar);
					}
				}
			}
			return operand;
		}
	
		private function getOperand(nestingLevel:int):Object
		{
			var operand:Object = this.tokeniser.getOperand();
			if (operand == Tokeniser.START_NEW_EXPRESSION)
			{
				operand = compileRecursive(null, null, nestingLevel + 1, ")", -1);
			}
			else if (operand is Operator)
			{
				/* Can get unary operators when expecting operand */
				return Operation.unaryOperationfactory(operand as Operator,
						getOperand(nestingLevel));
			}
			return operand;
		}
	}
}