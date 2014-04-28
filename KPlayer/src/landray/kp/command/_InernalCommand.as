package landray.kp.command
{
	import cn.vision.pattern.core.Command;
	
	import landray.kp.core.*;
	import landray.kp.manager.ManagerGraph;
	import landray.kp.manager.ManagerPage;
	
	import view.ui.Debugger;
	
	internal class _InernalCommand extends Command
	{
		public function _InernalCommand()
		{
			super();
			initialize();
		}
		private function initialize():void
		{
			config    = KPConfig   .instance;
			presenter = KPPresenter.instance;
			provider  = KPProvider .instance;
			
			graphManager = ManagerGraph.instance;
			pageManager  = ManagerPage .instance;
		}
		override protected function executeEnd():void
		{
			Debugger.debug(className + ".executeEnd()");
			super.executeEnd();
		}
		override protected function executeStart():void
		{
			Debugger.debug(className + ".executeStart()");
			super.executeStart();
		}
		public var config   :KPConfig;
		public var presenter:KPPresenter;
		public var provider :KPProvider;
		
		public var graphManager:ManagerGraph;
		public var pageManager :ManagerPage;
	}
}