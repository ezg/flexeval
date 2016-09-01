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
	/**
	 * A simple expression evaluator.
	 * <P>
	 * This is intended for use in simple domain specific languages, and was
	 * originally written for test configuration.
	 * <P>
	 * Example of use:
	 * 
	 * <PRE>
	 * var exp:Expression = new Expression(&quot;(x + y)/2&quot;);
	 * var variables:Array = new Array();		
	 * variables[&quot;x&quot;] = 4.32;
	 * variables[&quot;y&quot;] = 342.1;
	 * 
	 * var result:Number = exp.eval(variables);
	 * trace(result);
	 * 
	 * 
	 * </PRE>
	 * 
	 * <P>
	 * The following operators are supported:
	 * <UL>
	 * <LI>The basic arithmetic operations as provided by the
	 * class:
	 * <DL>
	 * <DT>+</DT>
	 * <DD>addition</DD>
	 * <DT>-</DT>
	 * <DD>subtraction</DD>
	 * <DT>*</DT>
	 * <DD>multiplication</DD>
	 * <DT>/</DT>
	 * <DD>division (rounds to 34 digits)</DD>
	 * <DT>%</DT>
	 * <DD>the remainder when dividing the preceding number by the following number
	 * (this is not module - the result can be negative, rounds to 34 digits)</DD>
	 * <DT>abs</DT>
	 * <DD>absolute of the following number (negative numbers have their sign
	 * reversed)</DD>
	 * <DT>pow</DT>
	 * <DD>raise the preceding number to the power of the following number (this
	 * can only raise to power of positive integers or zero)</DD>
	 * <DT>int</DT>
	 * <DD>round the following number to an integer</DD>
	 * </DL>
	 * <BR>
	 * </LI>
	 * <LI>Ternary (or conditional) expressions. <BR>
	 * <I>condition ? value-if-condition-is-true : value-if-condition-is-true</I><BR>
	 * For example:<BR>
	 * <CODE>x &gt; y ? x : y</CODE><BR>
	 * Yields the larger of the two variables x and y<BR>
	 * <BR>
	 * </LI>
	 * <LI>The following comparison operations:
	 * <DL>
	 * <DT>&lt;</DT>
	 * <DD>less than</DD>
	 * <DT>&lt;=</DT>
	 * <DD>less than or equals</DD>
	 * <DT>==</DT>
	 * <DD>equals</DD>
	 * <DT>&gt;</DT>
	 * <DD>greater than</DD>
	 * <DT>&gt;=</DT>
	 * <DD>greater than or equals</DD>
	 * <DT>!=</DT>
	 * <DT>&lt;&gt;</DT>
	 * <DD>not equals</DD>
	 * </DL>
	 * </LI>
	 * <BR>
	 * <LI>The following boolean operations:
	 * <DL>
	 * <DT>&amp;&amp;</DT>
	 * <DD>and</DD>
	 * <DT>||</DT>
	 * <DD>or</DD>
	 * </DL>
	 * </LI>
	 * </UL>
	 * 
	 * <P>
	 * Comparison and boolean operation yield 1 for true, or 0 for false if used
	 * directly.
	 * </P>
	 * 
	 * <P>
	 * Expressions are evaluated using the precedence rules found in Java, and
	 * parentheses can be used to control the evaluation order.
	 * <P>
	 * <P>
	 * Example expressions:
	 * 
	 * <PRE>
	 * 2*2
	 * 2+2
	 * 100/2
	 * x/100 * 17.5
	 * 2 pow 32 - 1
	 * 2 pow (32 - 1)
	 * 2 pow int 21.5
	 * abs -1.23E-12
	 * x &gt; y ? x : y
	 * x &gt; y &amp;&amp; x != 4 ? x : y
	 * y &gt; 4*x ? 4*y : z/3
	 * </PRE>
	 * 
	 * @author Reg Whitton
	 */
	public class Expression
	{
		/**
		 * The root of the tree of arithmetic operations.
		 */
		private var rootOperation:Operation;
	
		/**
		 * Construct an {@link Expression} that may be used multiple times to
		 * evaluate the expression using different sets of variables. This holds the
		 * results of parsing the expression to minimise further work.
		 * 
		 * @param expression
		 *            the arithmetic expression to be parsed.
		 */
		public function Expression(expression:String)
		{
			this.rootOperation = new Compiler(expression).compile();
		}
	
		/**
		 * Evaluate the expression with the given set of values.
		 * 
		 * @param variables
		 *            the values to use in the expression.
		 * @return the result of the evaluation
		 */
		public function eval(variables:Array = null):Number
		{
			return this.rootOperation.eval(variables);
		}
	
		/**
		 * A convenience method that constructs an {@link Expression} and evaluates
		 * it.
		 * 
		 * @param expression
		 *            the expression to evaluate.
		 * @param variables
		 *            the values to use in the evaluation.
		 * @return the result of the evaluation
		 */
		public static function eval(expression:String,
				variables:Array = null):Number
		{
			if (variables) {
				return new Expression(expression).eval(variables);
			}
			else {
				return new Expression(expression).eval();
			}
		}
	
		/**
		 * Creates a string showing expression as it has been parsed.
		 */
		public function toString():String
		{
			return this.rootOperation.toString();
		}
	}
}