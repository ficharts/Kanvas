package view.element.shapes
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ElementVO;
	import model.vo.ShapeVO;
	
	import util.ElementCreator;
	
	import view.element.ElementBase;
	
	/**
	 * 圆形
	 */
	public class Circle extends ShapeBase
	{
		public function Circle(vo:ShapeVO)
		{
			super(vo);
			
			xmlData = <circle/>
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return new Circle(cloneVO(new ShapeVO) as ShapeVO);
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
			
		}
		
	}
}