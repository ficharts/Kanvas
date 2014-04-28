package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ShapeVO;
		
	/**
	 * 等边三角形，通过控制点可以变成梯形或矩形
	 */	
	public class StepTriangle extends BaseShape
	{
		public function StepTriangle(vo:ShapeVO)
		{
			super(vo);
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				
				StyleManager.setShapeStyle(vo.style, graphics, vo);
				
				// 从等边三角形顶点开始绘制
				var startX:Number =   shapeVO.radius;
				var startY:Number = - shapeVO.height * .5;
				
				graphics.moveTo(   startX, startY );
				graphics.lineTo(   shapeVO.width * .5 , shapeVO.height * .5 );
				graphics.lineTo( - shapeVO.width * .5 , shapeVO.height * .5 );
				graphics.lineTo( - shapeVO.radius , startY);
				graphics.lineTo(   startX, startY );
				
				graphics.endFill();
			}
		}
	}
}