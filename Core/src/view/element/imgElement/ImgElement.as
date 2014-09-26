package view.element.imgElement
{
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
			
			_canvas.addChild(graphicShape);
			addChild(_canvas);
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
		}
		
		/**
		 */		
		override protected function initIMG(bmd:Object):void
		{
			if (bmd)
			{
				
			}
		}
		
		/**
		 */		
		override public function get canvas():DisplayObject
		{
			return _canvas;
		}
		
		/**
		 */		
		private var _canvas:Sprite = new Sprite;
		
		/**
		 */		
		override public function get shape():DisplayObject
		{
			return this;
		}
		
		/**
		 */		
		private var minSize   :Number = 400;
		
		private var bmdLarge:BitmapData;
	}
}