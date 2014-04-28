package model.vo
{
	/**
	 * 单箭头与双箭头的VO
	 */	
	public class ArrowVO extends ShapeVO
	{
		public function ArrowVO()
		{
			super();
		}
		
		/**
		 * 箭头的宽度
		 */		
		public var arrowWidth:Number = 60;
		
		/**
		 * 箭头尾巴的高度
		 */		
		public var trailHeight:Number = 48;
	}
}