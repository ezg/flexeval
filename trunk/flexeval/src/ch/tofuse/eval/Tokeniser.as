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
	import mx.utils.StringUtil;
	
	
	public class Tokeniser
	{
		public static var START_NEW_EXPRESSION:String = "(";
	
		private var string:String;
		private var position:int;
		private var pushedBackOperator:Operator = null;
	
		public function Tokeniser(string:String)
		{
			this.string = string;
			this.position = 0;
		}
	
		private function getPosition():int 
		{
			return this.position;
		}
	
		private function setPosition(position:int):void
		{
			this.position = position;
		}
	
		public function pushBack(operator:Operator):void
		{
			this.pushedBackOperator = operator;
		}
	
		public function getOperator(endOfExpressionChar:String):Operator
		{
			/* Use any pushed back operator. */
			if (this.pushedBackOperator != null)
			{
				var operator:Operator = this.pushedBackOperator;
				this.pushedBackOperator = null;
				return operator;
			}
	
			/* Skip whitespace */
			var len:int = this.string.length;
			//char ch = 0;
			var ch:String = String.fromCharCode(0);//"0";
			
			
			while (this.position < len
					&& StringUtil.isWhitespace(ch = this.string
							.charAt(this.position)))
			{
				this.position++;
			}
			if (this.position == len)
			{
				if (endOfExpressionChar == String.fromCharCode(0))
				{
					return Operator.END();
				}
				else
				{
					throw new Error("missing " + endOfExpressionChar);
				}
			}
	
			this.position++;
			if (ch == endOfExpressionChar)
			{
				return Operator.END();
			}
	
			switch (ch)
			{
				case '+':
				{
					return Operator.ADD();
				}
				case '-':
				{
					return Operator.SUB();
				}
				case '/':
				{
					return Operator.DIV();
				}
				case '%':
				{
					return Operator.REMAINDER();
				}
				case '*':
				{
					return Operator.MUL();
				}
				case '?':
				{
					return Operator.TERNARY();
				}
				case '>':
				{
					if (this.position < len
							&& this.string.charAt(this.position) == '=')
					{
						this.position++;
						return Operator.GE();
					}
					return Operator.GT();
				}
				case '<':
				{
					if (this.position < len)
					{
						switch (this.string.charAt(this.position))
						{
							case '=':
								this.position++;
								return Operator.LE();
							case '>':
								this.position++;
								return Operator.NE();
						}
					}
					return Operator.LT();
				}
				case '=':
				{
					if (this.position < len
							&& this.string.charAt(this.position) == '=')
					{
						this.position++;
						return Operator.EQ();
					}
					throw new Error("use == for equality at position "
							+ this.position);
				}
				case '!':
				{
					if (this.position < len
							&& this.string.charAt(this.position) == '=')
					{
						this.position++;
						return Operator.NE();
					}
					throw new Error(
							"use != or <> for inequality at position "
									+ this.position);
				}
				case '&':
				{
					if (this.position < len
							&& this.string.charAt(this.position) == '&')
					{
						this.position++;
						return Operator.AND();
					}
					throw new Error("use && for AND at position "
							+ this.position);
				}
				case '|':
				{
					if (this.position < len
							&& this.string.charAt(this.position) == '|')
					{
						this.position++;
						return Operator.OR();
					}
					throw new Error("use || for OR at position "
							+ this.position);
				}
				default:
				{
					/* Is this an identifier name for an operator function? */
					if (Functions.isUnicodeIdentifierStart(ch))
					{
						var start:int = this.position - 1;
						while (this.position < len
								&& Functions.isUnicodeIdentifierPart(this.string
										.charAt(this.position)))
						{
							this.position++;
						}
	
						var name:String = this.string.substring(start, this.position);
						if (name == "pow")
						{
							return Operator.POW();
						}
					}
					throw new Error("operator expected at position "
							+ this.position + " instead of '" + ch + "'");
				}
			}
		}
	
		/**
		 * Called when an operand is expected next.
		 * 
		 * @return one of:
		 *         <UL>
		 *         <LI>a {@link BigDecimal} value;</LI>
		 *         <LI>the {@link String} name of a variable;</LI>
		 *         <LI>{@link Tokeniser#START_NEW_EXPRESSION} when an opening
		 *         parenthesis is found: </LI>
		 *         <LI>or {@link Operator} when a unary operator is found in front
		 *         of an operand</LI>
		 *         </UL>
		 * 
		 * @throws RuntimeException
		 *             if the end of the string is reached unexpectedly.
		 */
		public function getOperand():Object
		{
			/* Skip whitespace */
			var len:int = this.string.length;
			var ch:String = String.fromCharCode(0);//"0";
			while (this.position < len
					&& StringUtil.isWhitespace(ch = this.string
							.charAt(this.position)))
			{
				this.position++;
			}
			if (this.position == len)
			{
				throw new Error(
						"operand expected but end of string found");
			}
	
			if (ch == '(')
			{
				this.position++;
				return START_NEW_EXPRESSION;
			}
			else if (ch == '-')
			{
				this.position++;
				return Operator.NEG();
			}
			else if (ch == '+')
			{
				this.position++;
				return Operator.PLUS();
			}
			else if (ch == '.' || Functions.isDigit(ch))
			{
				return getNumber();
			}
			else if (Functions.isUnicodeIdentifierStart(ch))
			{
				var start:int = this.position++;
				while (this.position < len
						&& Functions.isUnicodeIdentifierPart(this.string
								.charAt(this.position)))
				{
					this.position++;
				}
	
				var name:String = this.string.substring(start, this.position);
				/* Is variable name actually a keyword unary operator? */
				if (name == "abs")
				{
					return Operator.ABS();
				}
				else if (name == "int")
				{
					return Operator.INT();
				}
				/* Return variable name */
				return name;
			}
			throw new Error("operand expected but '" + ch + "' found");
		}
	
		private function getNumber():Number
		{
			var len:int = this.string.length;
			var start:int = this.position;
			var ch:String;
	
			while (this.position < len
					&& (Functions.isDigit(ch = this.string.charAt(this.position)) || ch == '.'))
			{
				this.position++;
			}
	
			/* Optional exponent part including another sign character. */
			if (this.position < len
					&& ((ch = this.string.charAt(this.position)) == 'E' || ch == 'e'))
			{
				this.position++;
				if (this.position < len
						&& ((ch = this.string.charAt(this.position)) == '+' || ch == '-'))
				{
					this.position++;
				}
				while (this.position < len
						&& Functions.isDigit(ch = this.string.charAt(this.position))
	
				)
				{
					this.position++;
				}
			}
			return parseFloat(this.string.substring(start, this.position));//new BigDecimal(this.string.substring(start, this.position));
		}
	
		public function toString():String
		{
			return this.string.substring(0, this.position) + ">>>"
					+ this.string.substring(this.position);
		}
	}
}
