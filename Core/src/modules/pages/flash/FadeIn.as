package modules.pages.flash
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.IElement;
	import view.ui.ICanvasLayout;

	/**
	 *
	 * 动画
	 *  
	 * @author wanglei
	 * 
	 */	
	public class FadeIn implements IFlash
	{
		/**
		 * 淡入
		 */		
		public static const FLASH_IN:String = "flashIn";
		
		/**
		 * 淡出
		 */		
		public static const FLASH_OUT:String = "flashOut";
		
		/**
		 * 动画播放的时间 
		 */		
		public static const TIME:Number = 0.5;
		
		/**
		 */		
		public function FadeIn():void
		{
			
		}
		
		/**
		 */		
		public function get key():String
		{
			return "fadeIn";
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
		 * 
		 * @return 
		 * 
		 */		
		public function expertData():XML
		{
			return <flashIn elementID={elementID} index={index}/>;;
		}
		
		/**
		 * 动画初始化, 预览时调用
		 */		
		public function start():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
				item.flashShape.alpha = 0;
		}
		
		/**
		 * 预览结束时调用
		 */		
		public function end():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
				item.flashShape.alpha = 1;
		}
		
		/**
		 * 动画播放
		 */		
		public function next():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
				TweenLite.to(item.flashShape, TIME, {alpha: 1});
			
		}
		
		/**
		 * 动画回退
		 */		
		public function prev():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
				TweenLite.to(item.flashShape, TIME, {alpha: 0});
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