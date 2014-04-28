package view.element.shapes
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import model.vo.ArrowVO;
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.customPoint.CustomPointControl;
	import view.elementSelector.customPoint.ICustomShape;
	
	/**
	 * 单箭头
	 */	
	public class Arrow extends ShapeBase implements ICustomShape
	{
		public function Arrow(vo:ShapeVO)
		{
			super(vo);
			
			xmlData = <arrow/>
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = super.exportData();
			
			xmlData.@arrowWidth = arrowVO.arrowWidth;
			xmlData.@trailHeight = arrowVO.trailHeight;
			
			return xmlData;
		}
		
		/**
		 */		
		public function customRender(selector:ElementSelector, control:CustomPointControl):void
		{
			var scale:Number = selector.layoutInfo.transformer.canvasScale * vo.scale;
			
			var w:Number = width  * .5;
			var h:Number = height * .5;
			
			var x:Number = MathUtil.clamp(selector.mouseX, - w * scale, w * scale);
			var y:Number = MathUtil.clamp(selector.mouseY, - h * scale, 0);
			
			arrowVO.arrowWidth  = (w * scale - x) / scale;
			arrowVO.trailHeight = - y * 2 / scale;
			
			render();
			selector.render();
		}
		
		/**
		 */		
		public function layoutCustomPoint(selector:ElementSelector, style:Style):void
		{
			selector.customPointControl.x = (width * .5 - arrowVO.arrowWidth) * style.scale;
			selector.customPointControl.y = - arrowVO.trailHeight * .5 * style.scale;
		}
		
		public function get propertyNameArray():Array
		{
			return _propertyNameArray;
		}
		
		private const _propertyNameArray:Array = ["arrowWidth", "trailHeight"];
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var newVO:ArrowVO = new ArrowVO;
			newVO.arrowWidth  = arrowVO.arrowWidth;
			newVO.trailHeight = arrowVO.trailHeight;
			
			return new Arrow(cloneVO(newVO) as ArrowVO);
		}
		
		/**
		 */		
		protected function get arrowVO():ArrowVO
		{
			return vo as ArrowVO;
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			StyleManager.setShapeStyle(vo.style, graphics, vo);
			
			// 从箭头的顶点开始绘制，顺时针绕一圈
			var w:Number = width  * .5;
			var h:Number = height * .5;
			graphics.moveTo( w, 0);
			graphics.lineTo( w -arrowVO.arrowWidth, h);
			graphics.lineTo( w -arrowVO.arrowWidth, arrowVO.trailHeight * .5);
			graphics.lineTo(-w, arrowVO.trailHeight * .5);
			
			//--------------------中轴线--------------------------------------------------------------
			
			graphics.lineTo(-w,- arrowVO.trailHeight * .5);
			graphics.lineTo( w - arrowVO.arrowWidth, - arrowVO.trailHeight * .5);
			graphics.lineTo( w - arrowVO.arrowWidth, - h);
			graphics.lineTo( w, 0);
			
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
		
		public var arrowWidth:Number = 0;
		
		public var trailHeight:Number = 0;
	}
	
}