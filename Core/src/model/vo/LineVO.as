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
		
		override public function set y(value:Number):void
		{
			_y = value;
			if (pageVO) 
			{
				pageVO.y = value + arc * .5;
			}
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			if (pageVO) 
			{
				pageVO.height = value + Math.abs(arc);
			}
		}
		
		
		/**
		 * 弧度
		 */
		public function get arc():Number
		{
			return _arc;
		}
		public function set arc(value:Number):void
		{
			_arc = value;
			if (pageVO) 
			{
				pageVO.y = value * .5 + y;
				pageVO.height = height + Math.abs(value);
			}
		}
		private var _arc:Number = 0;
		
		/**
		 * 线条长度就是宽度，线宽等于高度
		 */		
		override public function get height():Number
		{
			return this.thickness;
		}
	}
}