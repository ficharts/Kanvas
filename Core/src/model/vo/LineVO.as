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
		}
		
		override public function clone():ElementVO
		{
			var vo:LineVO = super.clone() as LineVO;
			vo.arc = arc;
			return vo;
		}
		
		override public function exportData(template:XML):XML
		{
			template = super.exportData(template);
			template.@arc = arc;
			template.@thickness = thickness;
			if (style && style.getBorder)
				template.@borderAlpha = style.getBorder.alpha;
			return template;
		}
		
		override public function updatePageLayout():void
		{
			if (pageVO) 
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
				pageVO.height = height + Math.abs(arc);
				pageVO.rotation = rotation;
			}
		}
		
		override public function set x(value:Number):void
		{
			_x = value;
			updatePageLayout();
		}
		
		override public function set y(value:Number):void
		{
			_y = value;
			updatePageLayout();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			updatePageLayout();
		}
		
		override public function set rotation(value:Number):void
		{
			_rotation = value;
			updatePageLayout();
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
			updatePageLayout();
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