package view.shapePanel.pageForCreateCompt
{
	import flash.events.Event;
	
	/**
	 * 图形创建面板中控制一级页与二级页之间的切换事件
	 */	
	public class ShapePageNavEvt extends Event
	{
		/**
		 * 跳转至图形创建主页 
		 */		
		public static const NAV_TO_HOME_PAGE:String = 'navToHomePage';
		
		/**
		 * 跳转到指定的图形创建二级页面 
		 */		
		public static const NAV_TO_TARGET_SHAPE_PAGE:String = 'navToTargetShapePage';
		
		/**
		 */		
		public function ShapePageNavEvt(type:String, pageID:String = null)
		{
			super(type, true);
			
			this.pageID = pageID;
			
		}
		
		/**
		 */		
		public var pageID:String = '';
		
		
	}
}