package view.element.shapes
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.ViewUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.vo.ElementVO;
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	import view.ui.canvas.Canvas;
	import view.ui.canvas.ElementLayoutModel;
	
	/**
	 * 图形基类
	 */
	public class ShapeBase extends ElementBase implements IAutoGroupElement
	{
		/**
		 * 
		 */		
		public function ShapeBase(vo:ShapeVO)
		{
			super(vo);
			
			initRenderPoints(4);
		}
		
		/**
		 */		
		override public function startDraw(canvas:Canvas):void
		{
			this.visible = false;
		}
		
		/**
		 */		
		override public function checkTrueRender():Boolean
		{
			return canvas.isLargeThanView(this);
		}
		
		/**
		 */		
		override public function drawView(canvas:Canvas):void
		{
			if (bmd == null) return;
			
			var rect:Rectangle = flashShape.getBounds(flashShape);
			
			renderPoints[0].x = rect.left;
			renderPoints[0].y = rect.top;
			
			renderPoints[1].x = rect.right;
			renderPoints[1].y = rect.top;
			
			renderPoints[2].x =  rect.right;
			renderPoints[2].y =  rect.bottom;
			
			renderPoints[3].x =  rect.left;
			renderPoints[3].y =  rect.bottom;
			
			var layout:ElementLayoutModel = canvas.getElementLayout(this);
			canvas.transformRenderPoints(renderPoints, layout);
			
			var math:Matrix = new Matrix;
			math.rotate(MathUtil.angleToRadian(layout.rotation));
			
			var scale:Number = rect.width * layout.scaleX / bmd.width;
			math.scale(scale, scale);
			
			var p:Point = renderPoints[0];
			
			math.tx = p.x;
			math.ty = p.y;
			
			canvas.graphics.beginBitmapFill(bmd, math, false, false);
			canvas.graphics.moveTo(p.x, p.y);
			
			p = renderPoints[1];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[2];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[3];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[0];
			canvas.graphics.lineTo(p.x, p.y);
			
			canvas.graphics.endFill();
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			super.exportData();
			
			if (vo.styleType == 'fill')
			{
				vo.xml.@fillAlpha = vo.style.getFill.alpha;
			}
			else if (vo.styleType == 'border' || vo.styleType == 'line')
			{
				vo.xml.@borderAlpha = vo.style.getBorder.alpha;
			}
			else if (vo.styleType == 'shape')
			{
				vo.xml.@borderColor = vo.style.getBorder.color.toString(16);
				vo.xml.@borderAlpha = vo.style.getBorder.alpha;
				vo.xml.@fillAlpha   = vo.style.getFill.alpha;
			}
			else
			{
				
			}
			
			return vo.xml;
		}
		
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			if (vo.styleType == 'fill')
			{
				toolbar.setCurToolBar(toolbar.fillShape);
			}
			else if (vo.styleType == 'border')
			{
				toolbar.setCurToolBar(toolbar.borderShape);
			}
			else if (vo.styleType == 'shape')
			{
				toolbar.setCurToolBar(toolbar.wholeShape);
			}
			else
			{
				toolbar.setCurToolBar(toolbar.defaultShape);
			}
		}
		
		/**
		 */		
		protected function get shapeVO():ShapeVO
		{
			return vo as ShapeVO;
		}
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			super.showControlPoints(selector);
			
			ViewUtil.show(selector.sizeControl);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			super.hideControlPoints(selector);
			
			ViewUtil.hide(selector.sizeControl)
		}
		
		/**
		 * 
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			super.hideFrameOnMdown(selector);
			
			ViewUtil.hide(selector.sizeControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			super.showSelectorFrame(selector);
			
			ViewUtil.show(selector.sizeControl);
		}
		
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			graphics.clear();
			
			// 中心点为注册点
			vo.style.tx = - vo.width / 2;
			vo.style.ty = - vo.height / 2;
			
			vo.style.width = vo.width;
			vo.style.height = vo.height;
		}
		
	}
}