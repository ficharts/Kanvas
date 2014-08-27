package view.interact.interactMode
{
	import com.kvs.utils.ViewUtil;
	
	import view.interact.CoreMediator;
	import view.ui.MainUIBase;
	
	/**
	 *
	 * 图表编辑模式
	 *  
	 * @author wanglei
	 * 
	 */	
	public class ChartEditMode extends ModeBase
	{
		public function ChartEditMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 */		
		override public function esc():void
		{
			mainMediator.mainUI.dispatchEvent(new KVSEvent(KVSEvent.TOOLBAR_TO_NORMAL));
			toSelectMode();
		}
		
		/**
		 */		
		override public function showSelector():void
		{
			mainMediator.selector.show(mainMediator.currentElement);
		}
		
		/**
		 */		
		override public function toSelectMode():void
		{
			ViewUtil.hide(mainMediator.coreApp.chartEditor);
			ViewUtil.show(mainMediator.canvas);
			mainMediator.showSelector();
			
			mainMediator.zoomMoveControl.enable();
			mainMediator.enableKeyboardControl();		
			
			mainMediator.currentMode = mainMediator.selectedMode;
		}
	}
}