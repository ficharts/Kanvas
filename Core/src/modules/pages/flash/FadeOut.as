package modules.pages.flash
{
	import com.greensock.TweenLite;
	
	import view.element.IElement;
	
	/**
	 *
	 * 淡出动画
	 *   
	 * @author wanglei
	 * 
	 */	
	public class FadeOut implements IFlash
	{
		public function FadeOut()
		{
		}
		
		/**
		 */		
		public function get key():String
		{
			return "out";
		}
		
		/**
		 */		
		public function get index():uint
		{
			return _index;
		}
		
		private var _index:uint = 0;
		
		/**
		 */		
		public function set index(value:uint):void
		{
			_index = value;
		}
		
		/**
		 */		
		public function clone():IFlash
		{
			return null;
		}
		
		/**
		 */		
		public function expertData():XML
		{
			return <fadeOut elementID={elementID} index={index}/>;
		}
		
		/**
		 */		
		public function start():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
				item.flashShape.alpha = 1;
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
				TweenLite.to(item.flashShape, FadeIn.TIME, {alpha: 0});
		}
		
		/**
		 */		
		public function prev():void
		{
			var elements:Vector.<IElement> = new Vector.<IElement>;
			elements = element.getChilds(elements);
			
			for each (var item:IElement in elements)
				TweenLite.to(item.flashShape, FadeIn.TIME, {alpha: 1});
		}
		
		/**
		 */		
		public function get element():IElement
		{
			return _ele;
		}
		
		public function set element(value:IElement):void
		{
			_ele = value;
		}
		
		/**
		 */		
		private var _ele:IElement;
		
		/**
		 */		
		public function get elementID():uint
		{
			return _eleID;
		}
		
		public function set elementID(value:uint):void
		{
			_eleID = value;
		}
		
		/**
		 */		
		private var _eleID:uint = 0;
	}
}