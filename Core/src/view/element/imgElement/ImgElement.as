package view.element.imgElement
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import model.vo.ImgVO;
	
	import util.ElementUtil;
	
	import view.element.ElementBase;
	import view.ui.canvas.Canvas;
	import view.ui.canvas.ElementLayoutModel;
	
	
	/**
	 * 图片
	 */
	public class ImgElement extends ImgElementBase
	{
		public function ImgElement(vo:ImgVO)
		{
			super(vo);
			
			_canvas.addChild(_shape);
			addChild(_canvas);
			
			//确保页码编号位于图片上
			addChild(pageNumCanvas);
			initRenderPoints(4);
		}
		
		/**
		 */		
		override public function startDraw(canvas:Canvas):void
		{
			super.startDraw(canvas);
		}
		
		/**
		 * 
		 */		
		override public function endDraw():void
		{
			super.endDraw();
		}
		
		/**
		 */		
		override public function drawView(canvas:Canvas):void
		{
			if (imgVO.viewData == null) return;
			if (canvas.checkVisible(this) == false) return;
			
			renderPoints[0].x = - vo.width / 2;
			renderPoints[0].y = - vo.height / 2;
			
			renderPoints[1].x =  vo.width / 2;
			renderPoints[1].y = - vo.height / 2;
			
			renderPoints[2].x =  vo.width / 2;
			renderPoints[2].y =  vo.height / 2;
			
			renderPoints[3].x =  - vo.width / 2;
			renderPoints[3].y =  vo.height / 2;
			
			var layout:ElementLayoutModel = canvas.getElementLayout(this);
			canvas.transformRenderPoints(renderPoints, layout);
			
			var math:Matrix = new Matrix;
			math.rotate(MathUtil.angleToRadian(layout.rotation));
			math.scale(layout.scaleX, layout.scaleY);
			
			var p:Point = renderPoints[0];
			math.tx = p.x;
			math.ty = p.y;
			
			canvas.graphics.beginBitmapFill(imgVO.viewData as BitmapData, math, false, false);
			
			canvas.graphics.moveTo(p.x, p.y);
			
			p = renderPoints[1]
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[2]
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[3]
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[3]
			canvas.graphics.lineTo(p.x, p.y);
			
			canvas.graphics.endFill();
		}
		
		/**
		 */
		override public function clone():ElementBase
		{
			var imgVO:ImgVO = new ImgVO;
			imgVO.viewData = this.imgVO.viewData;
			imgVO.url = this.imgVO.url;
			imgVO.imgID = this.imgVO.imgID;
			
			ElementUtil.cloneVO(imgVO, vo);
			
			var newElement:ImgElement = new ImgElement(imgVO);
			newElement.currLoadState = normalState;
			newElement.copyFrom = this;
			newElement.toNomalState();
			
			return newElement;
		}
		
		/**
		 */		
		override public function imgLoaded(fileBytes:ByteArray, viewData:Object):void
		{
			super.imgLoaded(fileBytes, viewData);
		}
		
		/**
		 */		
		override public function showIMG():void
		{
			this.graphics.clear();
			
			BitmapUtil.drawBitmapDataToGraphics(imgVO.viewData as BitmapData, graphics, vo.width, vo.height, - vo.width / 2, - vo.height / 2, true);
			
			
		}
		
		/**
		 */		
		override protected function initIMG(bmd:Object):void
		{
		}
		
		/**
		 */		
		override public function get flashShape():DisplayObject
		{
			return _canvas;
		}
		
		/**
		 */		
		private var _canvas:Sprite = new Sprite;
		
		/**
		 */		
		override public function get graphicShape():DisplayObject
		{
			return this;
		}
	}
}