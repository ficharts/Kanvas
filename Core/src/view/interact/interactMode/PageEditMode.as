package view.interact.interactMode
{
	import view.element.ElementBase;
	import view.interact.CoreMediator;
	
	/**
	 *
	 * 页面内容编辑状态，现用来编辑页面内容元素的闪现
	 *  
	 * @author wanglei
	 * 
	 */	
	public class PageEditMode extends ModeBase
	{
		public function PageEditMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 */		
		override public function startMoveEle(e:ElementBase):void
		{
			
		}
		
		/**
		 */		
		override public function stopMoveEle():void
		{
			
		}
		
		/**
		 */		
		override public function toUnSelectedMode():void
		{
			mainMediator.enableKeyboardControl();
			mainMediator.currentMode = mainMediator.unSelectedMode;
			
			mainMediator.zoomMoveControl.enable();
		}
	}
}