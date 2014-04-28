package cn.vision.pattern.core
{
	import cn.vision.containers.WebApplicaion;
	import cn.vision.core.vs;
	import cn.vision.core.VSEventDispatcher;
	import cn.vision.pattern.managers.ManagerCommand;
	import cn.vision.pattern.managers.ManagerModel;
	import cn.vision.utils.ClassUtil;
	
	import flash.display.DisplayObjectContainer;

	public class Presenter extends VSEventDispatcher
	{
		public function Presenter()
		{
			super();
			modelManager   = ManagerModel  .instance;
			commandManager = ManagerCommand.instance;
		}
		
		public function start($container:DisplayObjectContainer, ...$args):void
		{
			vs::container = $container;
			setup.apply(this, $args);
		}
		
		protected function setup(...$args):void { }
		
		public function get container():DisplayObjectContainer
		{
			return vs::container;
		}
		vs var container:DisplayObjectContainer;
		
		public var modelManager  :ManagerModel;
		public var commandManager:ManagerCommand;
		
		
	}
}