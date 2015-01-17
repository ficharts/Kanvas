package modules.pages.flash
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.LayoutUtil;
	
	import view.element.IElement;
	import view.ui.ICanvasLayout;
	
	/**
	 */	
	public class Fall implements IFlash
	{
		public function Fall()
		{
		}
		
		/**
		 */		
		public function get key():String
		{
			return "fall";
		}
		
		/**
		 */		
		private var _index:uint = 0;
		
		/**
		 * 在同一个页面中，动画的相对顺序 
		 */
		public function get index():uint
		{
			return _index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:uint):void
		{
			_index = value;
		}
		
		/**
		 */		
		public function clone():IFlash
		{
			return this;
		}
		
		/**
		 */		
		public function expertData():XML
		{
			return <fall elementID={elementID} index={index}/>;
		}
		
		/**
		 */		
		public function start():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
			item.flashShape.alpha = 0;
		}
		
		/**
		 */		
		public function end():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
			item.flashShape.alpha = 1;
		}	
		
		/**
		 */		
		public function next():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			var p:Point;
			
			for each (var item:IElement in elements)
			{
				//这里的飞入动画没有严格按照位置来做，先隐藏，需要动画的时候再计算起始的位置
				var rect:Rectangle = LayoutUtil.getItemRect(item.canvas, item as ICanvasLayout);
				p = item.canvas.stagePointToCanvas(item.canvas.canvasPointToStage(item.x, item.y).x, - rect.height);
				
				TweenLite.to(item.flashShape, FadeIn.TIME, {alpha: 1});
				TweenLite.from(item, FadeIn.TIME, {x: p.x, y: p.y, ease: Back.easeOut});
			}
		}
		
		/**
		 */		
		public function prev():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
			TweenLite.to(item.flashShape, FadeIn.TIME, {alpha: 0});
		}
		
		/**
		 */		
		private var _element:IElement;
		
		/**
		 * 动画播放的对象 
		 */
		public function get element():IElement
		{
			return _element;
		}
		
		/**
		 * @private
		 */
		public function set element(value:IElement):void
		{
			_element = value;
		}
		
		/**
		 */		
		private var _elementID:uint;
		
		/**
		 */
		public function get elementID():uint
		{
			return _elementID;
		}
		
		/**
		 * @private
		 */
		public function set elementID(value:uint):void
		{
			_elementID = value;
		}
	}
}