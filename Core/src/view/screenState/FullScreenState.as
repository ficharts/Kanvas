package view.screenState
{
	import view.ui.MainUIBase;

	/**
	 */	
	public class FullScreenState extends ScreenStateBase
	{
		public function FullScreenState(coreUI:MainUIBase)
		{
			super(coreUI);
		}
		
		/**
		 */		
		override public function toNormalState():void
		{
			mainUI.curScreenState = mainUI.normalState;
		}
	}
}