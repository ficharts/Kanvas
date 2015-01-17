package modules.pages.flash
{
	import view.element.IElement;
	import view.element.chart.IChartElement;
	
	/**
	 */	
	public class FlashChart implements IFlash
	{
		public function FlashChart()
		{
		}
		
		/**
		 */		
		public function get key():String
		{
			return "chart";
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
			return <flashChart elementID={elementID} index={index}/>;;
		}
		
		/**
		 * 动画初始化, 预览时调用
		 */		
		public function start():void
		{
			chart.resetFlash();
		}
		
		/**
		 * 预览结束时调用
		 */		
		public function end():void
		{
			chart.toFlashEnd();
				
		}
		
		/**
		 * 动画播放
		 */		
		public function next():void
		{
			chart.flash();
		}
		
		/**
		 * 动画回退
		 */		
		public function prev():void
		{
			chart.resetFlash();
		}
		
		/**
		 */		
		private var _element:IElement;
		
		/**
		 */		
		private function get chart():IChartElement
		{
			return element as IChartElement
		}
		
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