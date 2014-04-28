package landray.kp.command
{
	import landray.kp.core.kp_internal;
	
	public final class Command4Preview extends _InernalCommand
	{
		public function Command4Preview()
		{
			super();
			initialize();
		}
		private function initialize():void
		{
		}
		override public function execute():void
		{
			executeStart();
			config.kp_internal::viewer.kp_internal::centerAdaptive();
			config.kp_internal::controller.zoomAuto(config.originalScale);
			executeEnd();
		}
	}
}