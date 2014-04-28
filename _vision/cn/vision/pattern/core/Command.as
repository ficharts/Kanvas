package cn.vision.pattern.core
{
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.core.vs;
	import cn.vision.events.EventCommand;
	
	public class Command extends VSEventDispatcher
	{
		public function Command(repeatable:Boolean=false)
		{
			super();
			initialize(repeatable);
		}
		
		private function initialize(repeatable:Boolean=false):void
		{
			vs::repeatable = repeatable;
		}
		
		public function execute():void
		{
			executeStart();
			
			executeEnd();
		}
		
		public function redo():void
		{
			
		}
		public function undo():void
		{
			
		}
		
		protected function executeStart():void
		{
			dispatchEvent(new EventCommand(EventCommand.EXECUTE_START));
		}
		protected function executeEnd():void
		{
			dispatchEvent(new EventCommand(EventCommand.EXECUTE_END));
		}
		
		public function get repeatable():Boolean
		{
			return Boolean(vs::repeatable);
		}
		
		vs var repeatable:Boolean; 
	}
}