package view.ui
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface ICanvasLayout
	{
		function get scaledWidth ():Number
		function get scaledHeight():Number
		
		function get topLeft     ():Point
		function get topCenter   ():Point
		function get topRight    ():Point
		function get middleLeft  ():Point
		function get middleCenter():Point
		function get middleRight ():Point
		function get bottomLeft  ():Point
		function get bottomCenter():Point
		function get bottomRight ():Point
			
		function get left  ():Number
		function get right ():Number
		function get top   ():Number
		function get bottom():Number
			
		function get visible():Boolean
		function set visible(value:Boolean):void
			
		function set alpha(value:Number):void
			
		function get screenshot():Boolean
			
		function get index():int
		
		function updateView(check:Boolean = true):void
		function toShotcut(renderable:Boolean = false):void
		function toPreview(renderable:Boolean = false):void
	}
}