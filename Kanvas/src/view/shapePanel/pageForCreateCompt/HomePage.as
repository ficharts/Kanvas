package view.shapePanel.pageForCreateCompt
{
	import flash.events.MouseEvent;
	
	import view.ItemSelector;

	/**
	 * 图形创建主页面，从这里进入到具体的图形创建页
	 * 
	 * 不同二级页的图形类型不同
	 */	
	public class HomePage extends ItemSelectorPageBase
	{
		public function HomePage()
		{
			super();
		}
		
		/**
		 */		
		override protected function init():void
		{
			iconSize = 46;
			
			super.init();
			
			this.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		}
		
		/**
		 */		
		private function clickHandler(evt:MouseEvent):void
		{
			if (evt.target is ItemSelector)
				this.dispatchEvent(new ShapePageNavEvt(ShapePageNavEvt.NAV_TO_TARGET_SHAPE_PAGE, (evt.target as ItemSelector).type));
		}
	}
}