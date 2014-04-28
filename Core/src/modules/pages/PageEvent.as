package modules.pages
{
	import flash.events.Event;
	
	import model.vo.ElementVO;
	import model.vo.PageVO;
	
	/**
	 */	
	public final class PageEvent extends Event
	{
		/**
		 * 页面编号被点击，页面自适应
		 */		
		public static const PAGE_NUM_CLICKED:String = "pageNumClicked";
		
		/**
		 * 页面被添加后触发事件 
		 */				
		public static const PAGE_ADDED:String = "pageAdded";
		
		/**
		 * 页面被删除后触发
		 */		
		public static const PAGE_DELETED:String = "pageDeleted";
		
		/**
		 * 主UI上点击删除按钮后触发 
		 */		
		public static const DELETE_PAGE_FROM_UI:String = "deletePageFromUI";
		
		/**
		 */		
		public static const PAGE_SELECTED:String = "pageSelected";
		
		/**
		 * 通知主UI刷新页面布局 
		 */		
		public static const UPDATE_PAGES_LAYOUT:String = "updatePagesLayout";
		
		/**
		 * 通知页面UI刷新截图 
		 */		
		public static const UPDATE_THUMB:String = "updateThumb";
		
		
		/**
		 * 调节页面位置后触发，用来刷新页面编号 
		 */		
		public static const UPDATE_PAGE_INDEX:String = "updatePageIndex";
		
		
		/**
		 */		
		public function PageEvent(type:String, $vo:ElementVO = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			__vo = $vo;
			if (vo is PageVO)
			{
				__pageVO = PageVO(vo);
			}
		}
		
		override public function clone():Event
		{
			return new PageEvent(type, __pageVO, true);
		}
		
		public function get pageVO():PageVO
		{
			return  __pageVO;
		}
		
		private var __pageVO:PageVO;
		
		public function get vo():ElementVO
		{
			return  __vo;
		}
		private var __vo:ElementVO;
	}
}