package view.templatePanel
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.scroll.IVScrollView;
	import com.kvs.ui.scroll.VScrollControl;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 */	
	public class TemplatesScrollProxy implements IVScrollView
	{
		public function TemplatesScrollProxy(panel:TemplatePanel)
		{
			this.panel = panel;
			vScrollControl = new VScrollControl(this);
			vScrollControl.barWidth = 6;
		}
		
		/**
		 */		
		private var panel:TemplatePanel;
		
		/**
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
			return panel.templatesContainer;
		}
		
		/**
		 * 绘制滚动区域的遮罩
		 */		
		public function get maskRect():Rectangle
		{
			maskRectangle.x = 0;
			maskRectangle.y = panel.barHeight;
			maskRectangle.width = viewWidth;
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
			return panel.h - panel.barHeight * 2;
		}
		
		/**
		 */		
		public function get viewWidth():Number
		{
			return panel.w - 20;
		}
		
		/**
		 * 整个内容的高度
		 */		
		public function get fullSize():Number
		{
			return panel.fullSize;
		}
		
		/**
		 */		
		public function get off():Number
		{
			return panel.templatesContainer.y;
		}
		
		/**
		 */		
		public function set off(value:Number):void
		{
			panel.templatesContainer.y = value// + panel.barHeight;
		}
		
		/**
		 */		
		public function get viewForScrolled():DisplayObject
		{
			return panel.templatesContainer;
		}
	}
}