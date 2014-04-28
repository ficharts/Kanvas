package landray.kp.maps.main.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ShapeVO;
		
	public final class Diamond extends BaseShape
	{
		public function Diamond(vo:ShapeVO)
		{
			super(vo);
		}
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				
				StyleManager.setShapeStyle(shapeVO.style, graphics, shapeVO);
				
				graphics.moveTo( 0, - shapeVO.height * .5 );
				graphics.lineTo(   shapeVO.width * .5, 0 );
				graphics.lineTo( 0,   shapeVO.height * .5 );
				graphics.lineTo( - shapeVO.width * .5, 0 );
				graphics.lineTo( 0, - shapeVO.height * .5 );
				
				graphics.endFill();
			}
		}
	}
}