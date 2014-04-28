package cn.vision.core
{
	import cn.vision.core.vs;
	import cn.vision.interfaces.IExtra;
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.utils.ClassUtil;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class VSEventDispatcher extends EventDispatcher implements IExtra, IID, IName
	{
		public function VSEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get className():String
		{
			if(!vs::className)
				vs::className = ClassUtil.getClassName(this);
			return vs::className;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get extra():Object
		{
			if(!vs::extra)
				vs::extra = {};
			return vs::extra;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get id():String
		{
			return vs::id;
		}
		
		/**
		 * @private
		 */
		public function set id($value:String):void
		{
			vs::id = $value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String {return vs::name; }
		
		/**
		 * @private
		 */
		public function set name($value:String):void
		{
			vs::name = $value;
		}
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var extra:Object;
		
		/**
		 * @private
		 */
		vs var name:String;
		
		/**
		 * @private
		 */
		vs var id:String;
	}
}