package modules.pages.flash
{
	import view.element.ElementBase;
	
	/**
	 *
	 * 淡出动画
	 *   
	 * @author wanglei
	 * 
	 */	
	public class FlashOut implements IFlash
	{
		public function FlashOut()
		{
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
			return <flashOut elementID={elementID} index={index}/>;
		}
		
		/**
		 */		
		public function start():void
		{
		}
		
		public function end():void
		{
		}
		
		public function next():void
		{
		}
		
		public function prev():void
		{
		}
		
		public function get element():ElementBase
		{
			return _ele;
		}
		
		public function set element(value:ElementBase):void
		{
			_ele = value;
		}
		
		/**
		 */		
		private var _ele:ElementBase;
		
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