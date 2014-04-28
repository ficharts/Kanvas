package landray.kp.maps.main.elements
{
	import com.kvs.utils.graphic.BitmapUtil;
	
	import fl.motion.Source;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import landray.kp.ui.Loading;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	
	import view.ui.Debugger;
	
	/**
	 * 
	 */	
	public final class Image extends Element
	{
		public function Image($vo:ElementVO)
		{
			super($vo);
		}
		
		/**
		 */		
		public function showBmp():void
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
				if (bmpDispl.smoothing!= smooth)
					bmpDispl.smoothing = smooth;
			}
		}
		
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				
				if (CoreUtil.ifHasText(imgVO.url))// 再次编辑时从服务器载入图片
				{
					loader = new ImgInsertor;
					loader.addEventListener(ImgInsertEvent.IMG_LOADED, imgLoaded, false, 0, true);
					loader.addEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgError, false, 0, true);
					loader.loadImg(imgVO.url);
					toLoadingState();
				}
			}
		}
		
		/**
		 */		
		private function toNomalState():void
		{
			graphics.clear();
			showBmp();
		}
		
		/**
		 */		
		private function toLoadingState():void
		{
			drawLoading();
		}
		
		/**
		 */		
		private function drawLoading():void
		{
			graphics.clear();
			graphics.beginFill(0x555555, .3);
			graphics.drawRect( - vo.width * .5, - vo.height * .5, vo.width, vo.height);
			graphics.endFill();
			
			createLoading();
		}
		
		private function initBmp(bmd:BitmapData):void
		{
			if (bmd)
			{
				bmdLarge = bmd;
				bmpLarge = new Bitmap(bmdLarge);
				bmpLarge.visible = false;
				bmpLarge.width  =  vo.width;
				bmpLarge.height =  vo.height;
				bmpLarge.x = -.5 * vo.width;
				bmpLarge.y = -.5 * vo.height;
				bmpLarge.smoothing = true;
				addChild(bmpLarge);
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
					addChild(bmpSmall);
				}
			}
		}
		
		private function createLoading():void
		{
			if(!loading) 
				addChild(loading = new Loading);
			loading.play();
		}
		private function removeLoading():void
		{
			if (loading) 
			{
				if (contains(loading)) 
					removeChild(loading);
				loading.stop();
				loading = null;
			}
		}
		
		/**
		 */		
		private function imgLoaded(e:ImgInsertEvent):void
		{
			initBmp(e.bitmapData);
			
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED, imgLoaded);
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgError);
			loader = null;
			
			toNomalState();
			removeLoading();
		}
		
		/**
		 */		
		private function imgError(evt:ImgInsertEvent):void
		{
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED, imgLoaded);
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgError);
			loader = null;
			
			graphics.clear();
			
			graphics.beginFill(0xff0000, 0.3);
			graphics.drawRect( - vo.width * .5, - vo.height * .5, vo.width, vo.height);
			graphics.endFill();
			
			var iconSize:Number = (vo.width > vo.height) ? vo.height * 0.5 : vo.width * 0.5;
			BitmapUtil.drawBitmapDataToGraphics(new load_error, graphics, iconSize, iconSize, - iconSize * 0.5, - iconSize * 0.5, false);
			
			removeLoading();
		}
		
		public function get stageWidth():Number
		{
			return scaledWidth  * ((parent) ? parent.scaleX : 1);
		}
		
		public function get stageHeight():Number
		{
			return scaledHeight * ((parent) ? parent.scaleX : 1);
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
		
		private function get imgVO():ImgVO
		{
			return vo as ImgVO;
		}
		
		/**
		 */		
		private var loader :ImgInsertor;
		private var loading:Loading;
		
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