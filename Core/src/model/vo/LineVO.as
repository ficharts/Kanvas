package model.vo
{
	import com.kvs.utils.MathUtil;
	
	import flash.geom.Point;

	/**
	 */	
	public class LineVO extends ElementVO
	{
		public function LineVO()
		{
			super();
			
			this.type = 'line';
			this.styleType = 'line';
			
			this.thickness = 12;
		}
		
		/**
		 */		
		override public function set x(value:Number):void
		{
			_x = value;
			if (pageVO)
			{
				updatePosition();
			}
		}
		
		override public function set y(value:Number):void
		{
			_y = value;
			if (pageVO) 
			{
				updatePosition();
			}
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			if (pageVO) 
			{
				pageVO.height = height + Math.abs(arc);
			}
		}
		
		override public function set rotation(value:Number):void
		{
			_rotation = value;
			if (pageVO)
			{
				updatePosition();
			}
		}
		
		private function updatePosition():void
		{
			var p:Point = new Point(0, scale * .5 * arc);
			var radian:Number = MathUtil.angleToRadian(rotation);
			var cos:Number = Math.cos(radian);
			var sin:Number = Math.sin(radian);
			var rx:Number = p.x * cos - p.y * sin;
			var ry:Number = p.x * sin + p.y * cos;
			p.x = rx;
			p.y = ry;
			p.x += x;
			p.y += y;
			pageVO.x = p.x;
			pageVO.y = p.y;
			pageVO.rotation = rotation;
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
				pageVO.height = height + Math.abs(value);
				updatePosition();
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