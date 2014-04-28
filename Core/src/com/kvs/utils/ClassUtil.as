package com.kvs.utils
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 */	
	public class ClassUtil
	{
		public function ClassUtil()
		{
		}
		
		/**
		 * @return 
		 */		
		public static function getObjectByClassPath(path:String, parm:Object = null):Object
		{
			var result:Object;
			
			try
			{
				var TargetClass:Class = getDefinitionByName(path) as Class;
				
				if (parm)
					result = new TargetClass(parm);
				else
					result = new TargetClass();
			}
			catch (e:Error)
			{
				//trace("GET CLASS WRONG: " + path);
			}
			
			return result;
		}
		
		public static function isSubClass($value:Class, $superClass:Class):Boolean
		{
			var superClassName:String = getQualifiedSuperclassName($value);
			while ( superClassName )
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