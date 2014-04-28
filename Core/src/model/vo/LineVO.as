package model.vo
{
	/**
	 */	
	public class LineVO extends ElementVO
	{
		public function LineVO()
		{
			super();
			
			this.type = 'line';
			this.styleType = 'line';
		}
		
		/**
		 * 线条长度就是宽度，线宽等于高度
		 */		
		override public function get height():Number
		{
			return this.thickness;
		}
		
		/**
		 * 线条的弧度， 弧度控制点到起点与终点连线的距离 
		 */		
		public var arc:Number = 0;
	}
}