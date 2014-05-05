package view.element.shapes
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ArrowVO;
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	
	/**
	 * 双箭头
	 */	
	public class DoubleArrow extends Arrow
	{
		public function DoubleArrow(vo:ShapeVO)
		{
			super(vo);
			
			xmlData = <doubleArrow/>;
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			updateLayout();
			drawBG();
			
			graphics.clear();
			
			// 中心点为注册点
			vo.style.tx = - vo.width / 2;
			vo.style.ty = - vo.height / 2;
			
			vo.style.width = vo.width;
			vo.style.height = vo.height;
			
			StyleManager.setShapeStyle(vo.style, graphics, vo);
			
			// 从箭头的顶点开始绘制，顺时针绕一圈
			graphics.moveTo(vo.width / 2, 0);
			graphics.lineTo(vo.width / 2 - arrowVO.arrowWidth, vo.height / 2);
			graphics.lineTo(vo.width / 2 - arrowVO.arrowWidth, arrowVO.trailHeight / 2);
			
			graphics.lineTo( - vo.width / 2 + arrowVO.arrowWidth, arrowVO.trailHeight / 2);
			graphics.lineTo( - vo.width / 2 + arrowVO.arrowWidth, vo.height / 2);
			
			graphics.lineTo( - vo.width / 2, 0);
			
			graphics.lineTo( - vo.width / 2 + arrowVO.arrowWidth, - vo.height / 2);
			graphics.lineTo( - vo.width / 2 + arrowVO.arrowWidth, - arrowVO.trailHeight / 2);
			
			graphics.lineTo(vo.width / 2 - arrowVO.arrowWidth, - arrowVO.trailHeight / 2);
			graphics.lineTo(vo.width / 2 - arrowVO.arrowWidth, - vo.height / 2);
			graphics.moveTo(vo.width / 2, 0);
			
			graphics.endFill();
		}
		
	}
}