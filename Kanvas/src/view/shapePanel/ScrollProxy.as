package view.shapePanel
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.scroll.IVScrollView;
	import com.kvs.ui.scroll.VScrollControl;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 * 图形创建面板的内容滚动处理单元
	 */	
	public class ScrollProxy implements IVScrollView
	{
		/**
		 * 代理shapePanel实现滚动接口，加少其内部代码量
		 */		
		public function ScrollProxy(shapePanel:ShapePanel)
		{
			this.panel = shapePanel;
			vScrollControl = new VScrollControl(this);
			vScrollControl.ifBarRight = false;
			vScrollControl.barWidth = 6;
		}
		
		/**
		 * 滚动应用主体，滚动内容，滚动条，滚动内容的遮罩都会被添加到此容器上；
		 */		
		public function get scrollApp():FiUI
		{
			return panel;
		}
		
		/**
		 */		
		private var _rollContent:DisplayObject;
		
		public function get rollContent():DisplayObject
		{
			return _rollContent;
		}
		
		public function set rollContent(value:DisplayObject):void
		{
			_rollContent = value;
		}
		
		/**
		 * 放置滚动内容的根容器，此容器会被添加遮罩；
		 */		
		public function get viewCanvas():DisplayObjectContainer
		{
			return panel.pagesContainer;
		}
		
		/**
		 * 绘制滚动区域的遮罩
		 */		
		public function get maskRect():Rectangle
		{
			maskRectangle.x = 0;
			maskRectangle.y = panel.barHeight + panel.currentPage.gutter;
			maskRectangle.width = panel.w;
			maskRectangle.height = viewHeight;
			
			return maskRectangle;
		}
		
		/**
		 */		
		private var maskRectangle:Rectangle = new Rectangle;
		
		/**
		 */		
		private var vScrollControl:VScrollControl;
		
		/**
		 */		
		public function update():void
		{
			vScrollControl.update();
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
		private var panel:ShapePanel;
		
		/**
		 * 显示区域的高度, 为了让滚动内容顶部与滚动条顶部平齐
		 * 
		 * 滚动区域总高度减去了页面的顶部空白区
		 */		
		public function get viewHeight():Number
		{
			return panel.h - panel.barHeight - panel.currentPage.gutter;
		}
		
		/**
		 */		
		public function get viewWidth():Number
		{
			return panel.w - barSize;
		}
		
		/**
		 * 滚动条的宽度或者高度 
		 */		
		private var barSize:uint = 10;
		
		/**
		 * 整个内容的高度
		 */		
		public function get fullSize():Number
		{
			return panel.currentPage.pageHeight;
		}
		
		public function get off():Number
		{
			return this.panel.currentPage.y - panel.barHeight + panel.pagesContainer.y;
		}
		
		/**
		 */		
		public function set off(value:Number):void
		{
			panel.currentPage.y = value// + panel.barHeight;
		}
		
		/**
		 */		
		public function get viewForScrolled():DisplayObject
		{
			return panel.currentPage;
		}
	}
}