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
		
		/**
		 * 矩形的圆角，等边三角形的梯度，自定义三角形的顶点等
		 * 
		 * 自定义图形控制点的系数，不同图形所代表的意义不同；
		 */		
		public var radius:Number = 0;
		
		
		
	}
}