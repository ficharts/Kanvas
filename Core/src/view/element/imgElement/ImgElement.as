package view.element.imgElement
{
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import model.vo.ImgVO;
	
	import util.ElementUtil;
	
	import view.element.ElementBase;
	import view.ui.canvas.Canvas;
	
	
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
		}
		
		/**
		 */		
		override public function checkTrueRender():Boolean
		{
			return false;
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
			
			bmd = imgVO.viewData as BitmapData;
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