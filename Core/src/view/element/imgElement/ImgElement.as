package view.element.imgElement
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import model.vo.ImgVO;
	
	import util.ElementUtil;
	
	import view.element.ElementBase;
	
	
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
			if (bmpLarge && bmpSmall)
			{
				var tmpDispl:Bitmap = (stageWidth <= minSize || stageHeight <= minSize) ? bmpSmall : bmpLarge;
				
				if (tmpDispl != bmpDispl)
				{
					if (bmpDispl) bmpDispl.visible = false;
					
					bmpDispl = tmpDispl;
					bmpDispl.visible = true;
				}
				/*bmpDispl = true;
				if (bmpDispl.smoothing!= smooth)
					bmpDispl.smoothing = smooth;*/
			}
		}
		
		/**
		 */		
		override protected function initIMG(bmd:Object):void
		{
			if (bmd)
			{
				bmdLarge = bmd as BitmapData;
				bmpLarge = new Bitmap(bmdLarge);
				bmpLarge.visible = false;
				bmpLarge.width  =  vo.width;
				bmpLarge.height =  vo.height;
				bmpLarge.x = -.5 * vo.width;
				bmpLarge.y = -.5 * vo.height;
				bmpLarge.smoothing = true;
				_canvas.addChild(bmpLarge);
				
				
				if(!bmdSmall)
				{
					var ow:Number = bmdLarge.width;
					var oh:Number = bmdLarge.height;
					if (ow > minSize && oh > minSize)
					{
						var ss:Number = (ow > oh) ? minSize / oh : minSize / ow;
						bmdSmall = new BitmapData(ow * ss, oh * ss, true, 0);
						var matrix:Matrix = new Matrix;
						matrix.scale(ss, ss);
						bmdSmall.draw(bmdLarge, matrix, null, null, null, true);
					}
					else
					{
						bmdSmall = bmdLarge;
					}
					
					bmpSmall = new Bitmap(bmdSmall);
					bmpSmall.visible = false;
					bmpSmall.width  =  vo.width;
					bmpSmall.height =  vo.height;
					bmpSmall.x = -.5 * vo.width;
					bmpSmall.y = -.5 * vo.height;
					bmpSmall.smoothing = true;
					_canvas.addChild(bmpSmall);
				}
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
		public function checkBmdRender():void
		{
			var renderBmdNeeded:Boolean = (stageWidth > minSize && stageHeight > minSize)
				? (lastWidth <= minSize || lastHeight<= minSize)
				: (lastWidth > minSize && lastHeight > minSize);
			
			lastWidth  = width;
			lastHeight = height;
			
			if (renderBmdNeeded) showIMG();
		}
		
		public function get smooth():Boolean
		{
			return __smooth;
		}
		
		public function set smooth(value:Boolean):void
		{
			if (__smooth!= value)
			{
				__smooth = value;
				if (bmpSmall && bmpLarge)
				{
					if (smooth)
					{
						bmpSmall.visible = (stageWidth < minSize || stageHeight < minSize);
						bmpLarge.visible = !bmpSmall.visible;
					}
					else
					{
						bmpLarge.visible = false;
						bmpSmall.visible = true;
					}
				}
			}
		}
		
		private var __smooth:Boolean = true;
		
		/**
		 */		
		override public function get shape():DisplayObject
		{
			return this;
		}
		
		private var lastWidth :Number;
		private var lastHeight:Number;
		private var minSize   :Number = 400;
		
		private var bmdLarge:BitmapData;
		private var bmdSmall:BitmapData;
		private var bmpLarge:Bitmap;
		private var bmpSmall:Bitmap;
		private var bmpDispl:Bitmap;
	}
}