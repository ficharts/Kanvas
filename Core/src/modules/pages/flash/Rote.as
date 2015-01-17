package modules.pages.flash
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import view.element.IElement;
	
	public class Rote implements IFlash
	{
		public function Rote()
		{
		}
		
		/**
		 */		
		public function get key():String
		{
			return "rote";
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
			return <rote elementID={elementID} index={index}/>;
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
			
			for each (var item:IElement in elements)
			{
				TweenLite.to(item.flashShape, FadeIn.TIME, {alpha: 1});
				TweenLite.from(item, FadeIn.TIME, {scale: item['scale'] * 3, rotation: item['rotation'] - 180, ease: Back.easeOut});
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