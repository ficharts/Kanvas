package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ShapeVO;
	
	/**
	 * 三角形
	 */
	public class Triangle extends BaseShape
	{
		public function Triangle(vo:ShapeVO)
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
				
				StyleManager.setShapeStyle( shapeVO.style, graphics, shapeVO );
				
				// 从等边三角形顶点开始绘制
				var startX:Number =   shapeVO.radius + shapeVO.width * .5;
				var startY:Number = - shapeVO.height * .5 ;
				
				graphics.moveTo(   startX, startY );
				graphics.lineTo(   shapeVO.width * .5, shapeVO.height * .5 );
				graphics.lineTo( - shapeVO.width * .5, shapeVO.height * .5 );
				graphics.lineTo(   startX, startY );
				graphics.endFill();
			}
		}
	}
}