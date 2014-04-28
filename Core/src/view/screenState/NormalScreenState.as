package view.screenState
{
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;

	/**
	 */	
	public class NormalScreenState extends ScreenStateBase
	{
		public function NormalScreenState(coreUI:MainUIBase)
		{
			super(coreUI);
		}
		
		/**
		 */		
		override public function toFullScreenState():void
		{
			mainUI.curScreenState = mainUI.fullscreenState;
		}
		
		/**
		 */		
		override public function bgClicked(mediator:IMainUIMediator):void
		{
			mediator.bgClicked();
		}
		
		/**
		 */		
		override public function enableCanvas():void
		{
			mainUI.canvas.mouseChildren = mainUI.canvas.mouseEnabled = true;
		}
		
		/**
		 */		
		override public function disableCanvas():void
		{
			mainUI.canvas.mouseChildren = mainUI.canvas.mouseEnabled = false;
		}
	}
}