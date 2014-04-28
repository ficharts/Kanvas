package cn.vision.core
{
	import cn.vision.core.vs;
	import cn.vision.interfaces.*;
	import cn.vision.utils.ClassUtil;
	
	import flash.display.Sprite;
	
	use namespace vs;
	
	/**
	 * UI is the base class for all visible vision elements.
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 */
	public class UI extends Sprite implements IEnable, IExtra, IID, IName
	{
		public function UI()
		{
			super();
			initialize();
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			vs::enabled = true;
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
		public function get enabled():Boolean
		{
			return vs::enabled;
		}
		
		/**
		 * @private
		 */
		public function set enabled($value:Boolean):void
		{
			vs::enabled = $value;
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
		override public function get name():String
		{
			return super.name;
		}
		
		/**
		 * @private
		 */
		override public function set name($value:String):void
		{
			super.name = $value;
		}
		
		/**
		 * @private
		 */
		vs var className:String;
		
		/**
		 * @private
		 */
		vs var enabled:Boolean;
		
		/**
		 * @private
		 */
		vs var extra:Object;
		
		/**
		 * @private
		 */
		vs var id:String;
	}
}
