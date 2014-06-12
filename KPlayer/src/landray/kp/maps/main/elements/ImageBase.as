package landray.kp.maps.main.elements
{
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import landray.kp.ui.Loading;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	
	/**
	 *
	 * 图片的基类
	 *  
	 * @author wanglei
	 * 
	 */	
	public class ImageBase extends Element
	{
		public function ImageBase($vo:ElementVO)
		{
			super($vo);
		}
		
		/**
		 */		
		protected function initIMG(data:Object):void
		{
			
		}
		
		/**
		 */		
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
		private function imgLoaded(e:ImgInsertEvent):void
		{
			initIMG(e.viewData);
			
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
		
		/**
		 */		
		protected function toNomalState():void
		{
			graphics.clear();
			showIMG();
		}
		
		/**
		 */		
		public function showIMG():void
		{
			
		}
		
		/**
		 */		
		private function toLoadingState():void
		{
			drawLoading();
		}
		
		/**
		 */		
		private function createLoading():void
		{
			if(!loading) 
				addChild(loading = new Loading);
			
			loading.play();
		}
		
		/**
		 */		
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
		private function drawLoading():void
		{
			graphics.clear();
			graphics.beginFill(0x555555, .3);
			graphics.drawRect( - vo.width * .5, - vo.height * .5, vo.width, vo.height);
			graphics.endFill();
			
			createLoading();
		}
		
		/**
		 */		
		private function get imgVO():ImgVO
		{
			return vo as ImgVO;
		}
		
		public function get stageWidth():Number
		{
			return scaledWidth  * ((parent) ? parent.scaleX : 1);
		}
		
		public function get stageHeight():Number
		{
			return scaledHeight * ((parent) ? parent.scaleX : 1);
		}
		
		/**
		 */		
		protected var loader :ImgInsertor;
		protected var loading:Loading;
	}
}