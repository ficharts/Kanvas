package view.screenState
{
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;

	/**
	 * 全屏时，canva的交互式禁用的；
	 */	
	public class ScreenStateBase
	{
		public function ScreenStateBase(coreUI:MainUIBase)
		{
			this.mainUI = coreUI;
		}
		
		/**
		 */		
		protected var mainUI:MainUIBase;
		
		/**
		 */		
		public function toFullScreenState():void
		{
			
		}
		
		/**
		 */		
		public function toNormalState():void
		{
			
		}
		
		/**
		 */		
		public function enableCanvas():void
		{
			
		}
		
		/**
		 */		
		public function disableCanvas():void
		{
			
		}
		
		/**
		 */		
		public function bgClicked(mediator:IMainUIMediator):void
		{
			
		}
	}
}