package ch.tofuse.eval 
{
	import mx.utils.StringUtil;
	
	public class Functions
	{
		public static function signum(v:Number):int {
			if (v == 0) return 0;
			else if (v > 0) return 1;
			else return -1
		}
		
		public static function compareTo(v1:Number, v2:Number):int {
			if (v1 > v2) return 1;
			else if (v1 == v2) return 0;
			else return -1;
		}
		
		public static function isDigit(ch:String):Boolean {
			switch (ch) {
				case '0': {}
				case '1': {}
				case '2': {}
				case '3': {}
				case '4': {}
				case '5': {}
				case '6': {}
				case '7': {}
				case '8': {}
				case '9': {
					return true;
				}
				default: { 
					return false;
				}
			}
		}
		
		public static function isLetter(ch:String):Boolean {
			for (var i:int = 65; i <= 90; i++) {
				if (ch.toUpperCase() == String.fromCharCode(i)) {
					return true;
				}
			}
			return false;
		}
		
		public static function isUnicodeIdentifierStart(ch:String) :Boolean{
			return isLetter(ch);
		}
		
		public static function isUnicodeIdentifierPart(ch:String):Boolean {
			if (isLetter(ch) || isDigit(ch)) {
				return true;
			}
			return false;
		}
	}
}