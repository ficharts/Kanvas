package view.screenState
{
	import view.ui.IMainUIMediator;
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
		
		override public function bgClicked(mediator:IMainUIMediator):void
		{
			if (mediator.mainUI.stage.mouseX < 100 && mediator.mainUI.stage.mouseY > (mediator.mainUI.stage.stageHeight - 100))
			{
				CoreApp(mediator.mainUI).interact.show(0, (mediator.mainUI.stage.stageHeight - 100), 100, 100);
				CoreApp(mediator.mainUI).prevDrawMode = true;
			}
		}
	}
}