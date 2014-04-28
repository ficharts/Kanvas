package cn.vision.pattern.core
{
	import cn.vision.core.vs;
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.events.EventModel;
	import cn.vision.interfaces.IData;
	
	[Event(name="updateStart", type="cn.vision.events.EventModel")]
	
	[Event(name="updateEnd"  , type="cn.vision.events.EventModel")]
	
	/**
	 * Model use to process data.
	 */
	public class Model extends VSEventDispatcher implements IData
	{
		public function Model()
		{
			super();
		}
		public function execute():void
		{
			executeStart();
			
			executeEnd();
		}
		
		protected function executeStart():void
		{
			dispatchEvent(new EventModel(EventModel.UPDATE_START));
		}
		
		protected function executeEnd():void
		{
			dispatchEvent(new EventModel(EventModel.UPDATE_END));
		}
		
		public function get data():Object { return vs::data; }
		public function set data($value:Object):void
		{
			vs::data = $value;
		}
		vs var data:Object;
	}
}