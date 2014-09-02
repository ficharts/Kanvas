package view.ui
{
	import model.vo.ElementVO;
	
	import modules.pages.IPageManager;

	public interface IMainUIMediator
	{
		/**
		 * 画布控制动画开启时
		 */		
		function flashStart():void;
			
		/**
		 * 画布动画关闭时 
		 */		
		function flashStop():void;
		
		/**
		 * 画布缩放或移动后触发
		 */		
		function flashing():void;
		
		/**
		 * 主应用的背景被单击后触发
		 */		
		function bgClicked():void;
		
		/**
		 * 获取到住UI
		 */		
		function get mainUI():MainUIBase;
		
		/**
		 */		
		function get pagesMnger():IPageManager;
		
		/**
		 * 承载着翻页，平移原件的功能
		 */		
		function prev(xOff:Number = 0, yOff:Number = 0):void;
		
		/**
		 */		
		function next(xOff:Number = 0, yOff:Number = 0):void;
		
		/**
		 * 
		 * 根据元素的vo， 将镜头调整到刚好适应此元素
		 * 
		 */		
		function zoomElement(elementVO:ElementVO):void;
		
		/**
		 * 自适应整体画布
		 */		
		function zoomAuto():void;
		
		/**
		 * 设置当前的页面序号，仅仅设置，不做其他调整
		 * 
		 */		
		function setPageIndex(value:int):void;
		
		/**
		 */		
		function get canvas():Canvas
	}
}