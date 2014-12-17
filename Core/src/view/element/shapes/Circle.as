package view.element.shapes
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ShapeVO;
	
	/**
	 * 圆形
	 */
	public class Circle extends ShapeBase
	{
		public function Circle(vo:ShapeVO)
		{
			super(vo);
			
			vo.xml = <circle/>;
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			StyleManager.setShapeStyle(vo.style, graphics, vo);
			graphics.drawEllipse(vo.style.tx, vo.style.ty, vo.width, vo.height);
			graphics.endFill();
			
			bmd = canvas.getElemetBmd(flashShape);
		}
		
	}
}