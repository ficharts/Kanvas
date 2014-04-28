package cn.vision.interfaces
{
	public interface IName
	{
		/**
		 * 
		 * The class name of instance. 
		 * 
		 */
		function get className():String
		
		
		/**
		 * 
		 * The name of instance.
		 * 
		 */
		function get name():String
		
		/**
		 * @private
		 */
		function set name($value:String):void
	}
}