package view.interact.interactMode
{
	import view.interact.CoreMediator;
	
	/**
	 * 
	 * 视频播放模式
	 * 
	 * @author wanglei
	 * 
	 */	
	public class PlayMode extends ModeBase
	{
		public function PlayMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 */		
		override public function flashing():void
		{
			
		}
		
		/**
		 */		
		override public function flashStop():void
		{
			
		}
		
		/**
		 */		
		override public function toPrevMode():void
		{
			mainMediator.currentMode = mainMediator.preMode;
			mainMediator.previewCliker.enable = true;
		}
	}
}