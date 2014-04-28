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
	 * 矩形
	 */
	public class Rect extends ShapeBase implements ICustomShape
	{
		public function Rect(vo:ShapeVO)
		{
			super(vo);
			
			xmlData = <rect/>
		}
		
		/**
		 */		
		public function customRender(selector:ElementSelector, control:CustomPointControl):void
		{
			var scale:Number = selector.layoutInfo.transformer.canvasScale * vo.scale;
			var x:Number = selector.mouseX;
			
			if (x < - vo.width / 2 * scale)
				x = - vo.width / 2 * scale;
			
			if (x > 0)
				x = 0;
			
			rectVO.radius = (x + vo.width / 2 * scale) / scale;
			
			this.render();
			selector.render();
		}
		
		/**
		 */		
		public function layoutCustomPoint(selector:ElementSelector, style:Style):void
		{
			selector.customPointControl.x =(- vo.width  / 2 + rectVO.radius) * style.scale;
			selector.customPointControl.y = - vo.height / 2 * style.scale;
		}
		
		/**
		 */		
		public function get propertyNameArray():Array
		{
			return _propertyNameArray;
		}
		
		private const _propertyNameArray:Array = ["radius"];
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var rectVO:ShapeVO = new ShapeVO;
			rectVO.radius = this.rectVO.radius;
			
			return new Rect(cloneVO(rectVO) as ShapeVO);
		}
		
		/**
		 */		
		protected function get rectVO():ShapeVO
		{
			return vo as ShapeVO;
		}
			
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			vo.style.radius = rectVO.radius * 2;
			StyleManager.drawRect(this, vo.style, vo);
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