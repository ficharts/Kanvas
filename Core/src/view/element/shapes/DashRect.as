package view.element.shapes
{
	import com.kvs.utils.XMLConfigKit.style.elements.BorderLine;
	import com.kvs.utils.graphic.DashLine;
	
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	
	
	/**
	 * 虚线框
	 */	
	public class DashRect extends Rect
	{
		public function DashRect(vo:ShapeVO)
		{
			super(vo);
			
			xmlData = <dashRect/>
				
			dl = new DashLine(this, 1, 5);
		}
		
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var rectVO:ShapeVO = new ShapeVO;
			rectVO.radius = this.rectVO.radius;
			
			return new DashRect(cloneVO(rectVO) as ShapeVO);
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
			vo.style.radius = rectVO.radius * 2;
			
			this.graphics.beginFill(0, 0);
			this.graphics.drawRoundRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height, vo.style.radius);
			this.graphics.endFill();
			
			var thickness:uint = vo.thickness;
			if (thickness > 3)
				vo.thickness = thickness = 3;
			else if (thickness < 1)
				vo.thickness = thickness = 1;
			
			var lineStyle:BorderLine = vo.style.getBorder;
			dl.lineStyle(thickness, Number(vo.color), Number(lineStyle.alpha));
			dl.setDash(thickness, thickness * 2); 
			DashLine.curvedBox(dl, vo.style.tx, vo.style.ty, vo.style.width, vo.style.height, rectVO.radius);
		
			//trace(vo.thickness)
		}
		
		/**
		 */		
		private var dl:DashLine;
		
	}
}