
package view.interact.interactMode
{
	import commands.Command;
	
	import flash.ui.Mouse;
	
	import view.interact.CoreMediator;
	
	/**
	 * 预览模式
	 */	
	public class PrevMode extends ModeBase
	{
		public function PrevMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 */		
		override public function prev(xOff:Number, yOff:Number):void
		{
			mainMediator.pagesMnger.prev();
		}
		
		/**
		 */		
		override public function next(xOff:Number, yOff:Number):void
		{
			mainMediator.pagesMnger.next();
		}
		
		/**
		 */		
		override public function toPlayMode():void
		{
			mainMediator.currentMode = mainMediator.playMode;
			mainMediator.previewCliker.enable = false;
		}
		
		/**
		 */		
		override public function playElement():void
		{
			
		}
		
		/**
		 */		
		override public function autoZoom():void
		{
			mainMediator.pageManager.reset();
			mainMediator.sendNotification(Command.AUTO_ZOOM);
		}
		
		/**
		 */		
		override public function toUnSelectedMode():void
		{
			mainMediator.currentMode = mainMediator.unSelectedMode;
			mainMediator.currentMode.drawShotFrame();
			
			mainMediator.coreApp.clearDrawMode();
			mainMediator.coreApp.prevDrawMode = false;
			returnFromPrevState();
			
			mainMediator.previewCliker.enable = false;
			mainMediator.mouseController.autoHide = false;
			Mouse.show();
			
			//从演播模式退出后，画布继续停留在演播的位置
		}
	}
}