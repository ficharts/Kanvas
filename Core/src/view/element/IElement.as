package view.element
{
	import flash.display.DisplayObject;
	
	import model.vo.ElementVO;
	
	import view.ui.IMainUIMediator;
	import view.ui.canvas.Canvas;

	/**
	 * 原件的公共接口
	 */	
	public interface IElement
	{
		function get vo():ElementVO;
		function set vo(value:ElementVO):void;
		
		function get hasFlash():Boolean;
		
		/**
		 * 绘制内容的容器
		 */		
		function get graphicShape():DisplayObject
			
		function get flashShape():DisplayObject;
		
		/**
		 */		
		function clickedForPreview(cmt:IMainUIMediator):void;
		
		/**
		 */		
		function get canvas():Canvas
		
		/**
		 */		
		function getChilds(group:Vector.<IElement>):Vector.<IElement>
			
		function get x():Number
			
		function set x(value:Number):void;
		
		function set y(y:Number):void;
		function get y():Number;
	}
}