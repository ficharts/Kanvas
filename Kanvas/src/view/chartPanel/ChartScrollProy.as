package view.chartPanel
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.scroll.IVScrollView;
	import com.kvs.ui.scroll.VScrollControl;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 */	
	public class ChartScrollProy implements IVScrollView
	{
		public function ChartScrollProy(chartPanel:ChartPanel)
		{
			this.panel = chartPanel;
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
			return panel.chartPage;
		}
		
		/**
		 * 绘制滚动区域的遮罩
		 */		
		public function get maskRect():Rectangle
		{
			maskRectangle.x = 0;
			maskRectangle.y = panel.barHeight + panel.chartPage.gutter;
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
		 * 显示区域的高度, 为了让滚动内容顶部与滚动条顶部平齐
		 * 
		 * 滚动区域总高度减去了页面的顶部空白区
		 */		
		public function get viewHeight():Number
		{
			return panel.h - panel.barHeight - panel.chartPage.gutter;
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
			return panel.chartPage.pageHeight;
		}
		
		public function get off():Number
		{
			return this.panel.chartPage.y - panel.barHeight;
		}
		
		/**
		 */		
		public function set off(value:Number):void
		{
			panel.chartPage.y = value + panel.barHeight;
		}
		
		/**
		 */		
		public function get viewForScrolled():DisplayObject
		{
			return panel.chartPage;
		}
		
		
		/**
		 */		
		private var panel:ChartPanel;
	}
}