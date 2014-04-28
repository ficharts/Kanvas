package view.element.shapes
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	
	/**
	 * 菱形
	 */	
	public class Diamond extends ShapeBase
	{
		public function Diamond(vo:ShapeVO)
		{
			super(vo);
			
			xmlData = <diamond/>
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return new Diamond(cloneVO(new ShapeVO) as ShapeVO);
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			StyleManager.setShapeStyle(vo.style, graphics, vo);
			
			graphics.moveTo(0, - vo.height / 2);
			graphics.lineTo(vo.width / 2, 0);
			graphics.lineTo(0, vo.height / 2);
			graphics.lineTo(- vo.width / 2, 0);
			graphics.lineTo(0, - vo.height / 2);
			graphics.endFill();
		}
	}
}