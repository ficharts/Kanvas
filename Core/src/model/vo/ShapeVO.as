package model.vo
{
	
	/**
	 * 形状模型
	 */
	public class ShapeVO extends ElementVO 
	{
		/**
		 */		
		public function ShapeVO()
		{
			super();
		}
		
		override public function clone():ElementVO
		{
			var vo:ShapeVO = super.clone() as ShapeVO;
			vo.radius = radius;
			return vo;
		}
		
		override public function exportData():XML
		{
			xml = super.exportData();
			xml.@radius    = radius;
			xml.@thickness = thickness;
			return xml;
		}
		
		/**
		 * 矩形的圆角，等边三角形的梯度，自定义三角形的顶点等
		 * 
		 * 自定义图形控制点的系数，不同图形所代表的意义不同；
		 */		
		public var radius:Number = 0;
		
		
		
	}
}