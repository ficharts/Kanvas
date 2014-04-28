package view.element
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import model.vo.ElementVO;
	
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	public final class Camera extends ElementBase implements IAutoGroupElement
	{
		public function Camera(vo:ElementVO)
		{
			super(vo);
			_screenshot = false;
			xmlData = <camera/>;
			mouseChildren = false;
		}
		
		
		override protected function preRender():void
		{
			super.preRender();
			
			addChild(maskShape = new Shape);
			maskShape.graphics.beginFill(0, 0);
			maskShape.graphics.drawRect(0, 0, 1, 1);
			maskShape.graphics.endFill();
			
			graphicShape.mask = maskShape;
		}
		
		/**
		 * 热点在预览状态时不显示
		 */		
		override public function toPrevState():void
		{
			super.toPrevState();
			
			graphicShape.visible = false;
		}
		
		/**
		 */		
		override public function returnFromPrevState():void
		{
			super.returnFromPrevState();
			
			graphicShape.visible = true;
			
			this.render();
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			graphics.clear();
			
			// 中心点为注册点
			if (vo.style)
			{
				vo.style.tx = - width  * .5;
				vo.style.ty = - height * .5;
				
				vo.style.width  = width;
				vo.style.height = height;
				
				var left  :Number = vo.style.tx;
				var top   :Number = vo.style.ty;
				var right :Number = vo.style.tx + vo.style.width;
				var bottom:Number = vo.style.ty + vo.style.height;
				
				drawInteract(left, top, right - left, bottom - top);
				
				StyleManager.setLineStyle(graphics, vo.style.getBorder, vo.style, vo);
				
				var w:Number = 15;
				
				//leftTop
				graphics.moveTo(left, top);
				graphics.lineTo(left + w, top);
				graphics.moveTo(left, top);
				graphics.lineTo(left, top + w);
				//rightTop
				graphics.moveTo(right, top);
				graphics.lineTo(right - w, top);
				graphics.moveTo(right, top);
				graphics.lineTo(right, top + w);
				//leftBottom
				graphics.moveTo(left, bottom);
				graphics.lineTo(left + w, bottom);
				graphics.moveTo(left, bottom);
				graphics.lineTo(left, bottom - w);
				//rightBottom
				graphics.moveTo(right, bottom);
				graphics.lineTo(right - w, bottom);
				graphics.moveTo(right, bottom);
				graphics.lineTo(right, bottom - w);
				
				maskShape.x = vo.style.tx;
				maskShape.y = vo.style.ty;
				maskShape.width  = vo.style.width;
				maskShape.height = vo.style.height;
			}
		}
		
		
		private function drawInteract(x:Number, y:Number, w:Number, h:Number):void
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(x, y, w, h);
			graphics.endFill();
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var cameraVO:ElementVO = new ElementVO;
			return new Camera(cloneVO(cameraVO));
		}
		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.cameraShape);
		}
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = true;
			ViewUtil.show(selector.sizeControl);
			ViewUtil.show(selector.scaleRollControl);
		}
		
		/**
		 * 隐藏型变控制点， 图形被取消选择后会调用此方法
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = false;
			ViewUtil.hide(selector.sizeControl);
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			selector.frame.alpha = 0.5;
			ViewUtil.hide(selector.sizeControl);
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			selector.frame.alpha = 1;
			ViewUtil.show(selector.sizeControl);
			ViewUtil.show(selector.scaleRollControl);
		}
		
		
		private var maskShape:Shape;
	}
}