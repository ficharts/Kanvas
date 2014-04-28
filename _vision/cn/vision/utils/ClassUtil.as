package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * ClassUtil defines some function that is useful, 
	 * basicly the utils for class, function.
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 */
	public final class ClassUtil extends NoInstance
	{
		
		/**
		 * Get the class of instance.
		 * 
		 * @param $value istance.
		 * 
		 * @return <code>Class</code>
		 */
		public static function getClass($value:*):*
		{
			return getDefinitionByName(getQualifiedClassName($value));
		}
		
		/**
		 * Get the class name of instance.
		 * 
		 * @param $value The instance you.
		 * @param $qualified Return the qualified class name if true, default false.
		 * 
		 * @return <code>String</code>
		 */
		public static function getClassName($value:*, $qualified:Boolean = false):String
		{
			var qualifiedClassName:String = getQualifiedClassName($value);
			var index:int = -1;
			if ($qualified) 
				index = qualifiedClassName.indexOf("::");
			return (index==-1)?qualifiedClassName:qualifiedClassName.substr(index+2);
		}
		
		/**
		 * Get the function name of a Function.
		 * 
		 * @param $value <code>Function</code>.
		 * 
		 * @return <code>String</code>
		 */
		public static function getFunctionName($value:Function = null):String
		{
			var result:String;
			if ($value is Function) 
			{
				try
				{
					NoInstance($value);
				}
				catch(error:Error)
				{
					// start of first line
					var startIndex:int = error.message.indexOf("/");
					// end of function name
					var endIndex  :int = error.message.indexOf("()");
					result = error.message.substring(startIndex + 1, endIndex);
				}
			}
			return result;
		}
		
		/**
		 * Get the super class name of instance.
		 * It will return an <code>Array</code> that contains 
		 * a series of super class name at the series you seted.
		 * if level = 0, will not set the series an to Object class.
		 * if level > 0, will to the series you seted.
		 * if the super class series is less than the series you seted,
		 * it will to the super class series.
		 * 
		 * @param $value The istance.
		 * @param $qualified Return the qualified class name if true, default false.
		 * @param $level The number of parent level you want to get, default 1.
		 * 
		 * @return <code>Array</code>
		 */
		public static function getSuperClassNameArray($value:*, $qualified:Boolean = false, $level:uint = 1):Array
		{
			var index:int = -1;
			var superClassNameArray:Array = [];
			var superClassName:String = getQualifiedSuperclassName($value);
			while ($level >= 0 && superClassName) 
			{
				if ($qualified) index = superClassName.indexOf("::");
				superClassNameArray.push((index == -1)
					? superClassName
					: superClassName.substr(index + 2));
				if ($level != 1) 
				{
					superClassName = getQualifiedSuperclassName(getDefinitionByName(superClassName));
					if ($level > 1) $level--;
				} else break;
			}
			return superClassNameArray;
		}
		
		/**
		 * Check whether value class is the sub class of the super class.
		 * 
		 * @param $value value class
		 * @param $superClass super class
		 * 
		 * @return <code>Boolean</code>
		 */
		public static function isSubClass($value:Class, $superClass:Class):Boolean
		{
			var superClassName:String = getQualifiedSuperclassName($value);
			while ( superClassName)
			{
				if( superClassName== getQualifiedClassName($superClass))
					return true;
				else
					superClassName = getQualifiedSuperclassName(getDefinitionByName(superClassName));
			}
			return false;
		}
	}
}