package cn.vision.events
{
	import cn.vision.core.vs;
	import cn.vision.interfaces.IExtra;
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.utils.ClassUtil;
	
	import flash.events.Event;
	
	use namespace vs;
	
	public class VSEvent extends Event implements IExtra, IID, IName
	{
		public function VSEvent($type:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
		}
		
		public function get className():String
		{
			if(!vs::className)
				vs::className = ClassUtil.getClassName(this);
			return vs::className;
		}
		
		public function get extra():Object
		{
			if(!vs::extra)
				vs::extra = {};
			return vs::extra;
		}
		
		public function get id():String
		{
			return vs::id;
		}
		public function set id($value:String):void
		{
			vs::id = $value;
		}
		
		public function get name():String
		{
			return vs::name;
		}
		public function set name($value:String):void
		{
			vs::name = $value;
		}
		
		vs var className:String;
		vs var extra:Object;
		vs var name:String;
		vs var id:String;
	}
}