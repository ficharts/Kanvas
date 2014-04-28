package view.pagePanel
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.scroll.IVScrollView;
	import com.kvs.ui.scroll.VScrollControl;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 */	
	public class PagesScrollProxy implements IVScrollView
	{
		public function PagesScrollProxy(panel:PagePanel)
		{
			this.pagesPanel = panel;
			vScrollControl = new VScrollControl(this);
			vScrollControl.barWidth = 6;
		}
		
		/**
		 */		
		public function scrollTo(start:Number, end:Number):void
		{
			vScrollControl.scrollTo(start, end);
		}
		
		/**
		 */		
		public function update():void
		{
			vScrollControl.update();
		}
		
		/**
		 * 页面添加内容后，仅仅刷新滚动条
		 */		
		public function updateScrollBar():void
		{
			vScrollControl.update(false);
		}
		
		/**
		 * 仅有初始化和尺寸缩放时才会刷新遮罩区域
		 */		
		public function updateMask():void
		{
			vScrollControl.updateMaskArea();
		}
		
		/**
		 */		
		private var pagesPanel:PagePanel;
		
		/**
		 */		
		private var vScrollControl:VScrollControl;
		
		/**
		 */		
		public function get rollContent():DisplayObject
		{
			return _rollContent;
		}
		
		/**
		 */		
		public function set rollContent(value:DisplayObject):void
		{
			_rollContent = value;
		}
		
		/**
		 */		
		private var _rollContent:DisplayObject;
		
		/**
		 */		
		public function get scrollApp():FiUI
		{
			return pagesPanel;
		}
		
		/**
		 */		
		public function get viewCanvas():DisplayObjectContainer
		{
			return pagesPanel.pagesCtn;
		}
		
		/**
		 */		
		public function get maskRect():Rectangle
		{
			maskRectangle.x = 0;
			maskRectangle.y = 0;
			maskRectangle.width = viewWidth;
			maskRectangle.height = viewHeight;
			
			return maskRectangle;
		}
		
		/**
		 */		
		private var maskRectangle:Rectangle = new Rectangle;
		
		/**
		 */		
		public function get viewHeight():Number
		{
			return pagesPanel.h - pagesPanel.addPageBtn.h - pagesPanel.gutter * 2;
		}
		
		/**
		 */		
		public function get viewWidth():Number
		{
			return pagesPanel.w;
		}
		
		public function get fullSize():Number
		{
			return pagesPanel.pagesCtn.height //+ pagesPanel.gutter * 2;
		}
		
		public function get off():Number
		{
			return pagesPanel.pagesCtn.y;
		}
		
		public function set off(value:Number):void
		{
			pagesPanel.pagesCtn.y = value;
		}
		
		/**
		 */		
		public function get viewForScrolled():DisplayObject
		{
			return pagesPanel.pagesCtn;
		}
	}
}