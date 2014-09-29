package view.element
{
	import flash.display.DisplayObject;
	
	import model.vo.ElementVO;
	
	import view.ui.IMainUIMediator;

	/**
	 * 原件的公共接口
	 */	
	public interface IElement
	{
		function get vo():ElementVO;
		function set vo(value:ElementVO):void;
		
		/**
		 * 绘制内容的容器
		 */		
		function get graphicShape():DisplayObject
			
		function get flashShape():DisplayObject;
		
		/**
		 */		
		function clickedForPreview(cmt:IMainUIMediator):void;
		
		/**
		 * 
		 */		
		function getChilds(group:Vector.<IElement>):Vector.<IElement>
	}
}