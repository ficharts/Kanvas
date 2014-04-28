package cn.vision.pattern.managers
{
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.events.EventManager;
	
	[Event(name="queneEnd"  , type="cn.vision.events.EventManager")]
	
	[Event(name="queneStart", type="cn.vision.events.EventManager")]
	
	[Event(name="stepEnd"   , type="cn.vision.events.EventManager")]
	
	[Event(name="stepStart" , type="cn.vision.events.EventManager")]
	
	public class Manager extends VSEventDispatcher
	{
		public function Manager()
		{
			super();
		}
		
		protected function stepStart():void
		{
			dispatchEvent(new EventManager(EventManager.STEP_START));
		}
		protected function stepEnd():void
		{
			dispatchEvent(new EventManager(EventManager.STEP_END));
		}
		protected function queneStart():void
		{
			dispatchEvent(new EventManager(EventManager.QUENE_START));
		}
		protected function queneEnd():void
		{
			dispatchEvent(new EventManager(EventManager.QUENE_END));
		}
	}
}