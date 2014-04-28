package view.pagePanel
{
	import flash.events.Event;
	
	/**
	 */	
	public class PagePanelEvent extends Event
	{
		
		/**
		 * 开始拖动列表中的页面
		 */		
		public static const START_DRAG_PAGE:String = 'startDragPage';
		
		
		/**
		 * 停止拖动列表中的页面
		 */		
		public static const END_DRAG_PAGE:String = 'endDragPage';
		
		
		/**
		 * 正在拖动列表中的页面
		 */		
		public static const PAGE_DRAGGING:String = 'pageDragging';
		
		/**
		 * 此时才触发镜头的页面切换，单纯鼠标按下并不触发镜头切换至当前页面 
		 */		
		public static const PAGE_CLICKED:String = 'pageClicked';
		
		/**
		 */		
		public static const PAGE_DOWN:String = 'pageDown';
		
		/**
		 */		
		public function PagePanelEvent(type:String, pageUI:PageUI = null)
		{
			super(type, true);
			
			this.pageUI = pageUI;
		}
		
		public var pageUI:PageUI;
	}
}