package model
{
	import flash.geom.Rectangle;

	/**
	 * 创建图形时，外部UI需要构建此对象，设定图形
	 * 
	 * 创建位置，大小，图形的类型及样式等属性
	 */	
	public class ElementProxy
	{
		public function ElementProxy()
		{
		}
		
		public var index:int = 0;
		
		/**
		 */		
		public var radius:Number = 0;
		
		/**
		 */		
		public var x:Number = 0;
		
		/**
		 */		
		public var y:Number = 0;
		
		/**
		 */		
		public var width:Number = 0;
		
		/**
		 */		
		public var height:Number = 0;
		
		/**
		 */		
		public var type:String = '';
		
		/**
		 */		
		public var rotation:Number = 0;
		
		/**
		 * 样式ID
		 */		
		public var styleID:String = 'Fill';
		
		/**
		 * 样式类型
		 */		
		public var styleType:String = '';
		
		/**
		 * 拖动创建和点击创建图形的动画时间不同，所以要靠此属性传递给图形创建动画
		 */		
		public var flashTime:Number = 1;
		
		/**
		 */		
		public var ifSelectedAfterCreate:Boolean = true;
		
	}
}