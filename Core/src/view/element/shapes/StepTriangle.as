package view.element.shapes
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.customPoint.CustomPointControl;
	import view.elementSelector.customPoint.ICustomShape;
	
	/**
	 * 等边三角形，通过控制点可以变成梯形或矩形
	 */	
	public class StepTriangle extends ShapeBase implements ICustomShape
	{
		public function StepTriangle(vo:ShapeVO)
		{
			super(vo);
			
			xmlData = <stepTriangle/>;
		}
		
		/**
		 */		
		public function customRender(selector:ElementSelector, control:CustomPointControl):void
		{
			var scale:Number = selector.layoutInfo.transformer.canvasScale * vo.scale;
			var x:Number = selector.mouseX;
			
			if (x > vo.width / 2 * scale)
				x = vo.width / 2 * scale;
			
			if (x < 0)
				x = 0;
			
			shapeVO.radius = x / scale;
			
			this.render();
			selector.render();
		}
		
		/**
		 */		
		public function layoutCustomPoint(selector:ElementSelector, style:Style):void
		{
			selector.customPointControl.x = shapeVO.radius * style.scale;
			selector.customPointControl.y = - vo.height / 2 * style.scale;
		}
		
		
		public function get propertyNameArray():Array
		{
			return _propertyNameArray;
		}
		
		private const _propertyNameArray:Array = ["radius"];
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var newVO:ShapeVO = new ShapeVO;
			newVO.radius = this.shapeVO.radius;
			
			return new StepTriangle(cloneVO(newVO) as ShapeVO);
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			StyleManager.setShapeStyle(vo.style, graphics, vo);
			
			// 从等边三角形顶点开始绘制
			var startX:Number = shapeVO.radius;
			var startY:Number = - vo.height / 2;
			
			graphics.moveTo(startX, startY);
			graphics.lineTo(vo.width / 2 , vo.height / 2);
			graphics.lineTo(- vo.width / 2 , vo.height / 2);
			graphics.lineTo(- shapeVO.radius , startY);
			graphics.lineTo(startX , startY);
			graphics.endFill();
		}
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			super.showControlPoints(selector);
			
			ViewUtil.show(selector.customPointControl);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			super.hideControlPoints(selector);
			
			ViewUtil.hide(selector.customPointControl)
		}
		
		/**
		 * 
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			super.hideFrameOnMdown(selector);
			
			ViewUtil.hide(selector.customPointControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			super.showSelectorFrame(selector);
			
			ViewUtil.show(selector.customPointControl);
		}
	}
}