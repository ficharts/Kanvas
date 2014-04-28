package view.element.imgElement
{
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Shape;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	import util.img.ImgLib;
	
	import view.element.ElementEvent;

	public class LoadingState extends ImgLoadStateBase
	{
		public function LoadingState(host:ImgElement)
		{
			super(host);
		}
		
		/**
		 */		
		override public function render():void
		{
			element.drawLoading();
		}
		
		/**
		 * 这里加载图片分两种情况，web方式从服务器端加载
		 * 
		 * 直接从内存中加载，此情况用于air客户端打开文件的场景
		 */		
		override public function loadingImg():void
		{
			imgLoader.addEventListener(ImgInsertEvent.IMG_LOADED, imgLoaded, false, 0, true);
			imgLoader.addEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError, false, 0, true);
			
			if (ImgLib.ifHasData(element.imgVO.imgID))
				imgLoader.loadImgBytes(ImgLib.getData(element.imgVO.imgID));
			else
				imgLoader.loadImg(element.imgVO.url);
			
			render();
		}
		
		/**
		 */		
		private function imgLoadError(evt:ImgInsertEvent):void
		{
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED, imgLoaded);
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError);
			imgLoader = null;
			
			element.currLoadState = element.normalState;
			
			element.graphics.clear();
			element.shape.visible = true;
			element.graphics.clear();
			element.graphics.beginFill(0xff0000, 0.3);
			element.graphics.drawRect( - element.vo.width / 2, - element.vo.height / 2, element.vo.width, element.vo.height);
			element.graphics.endFill();
			
			var iconSize:Number = (element.vo.width > element.vo.height) ? element.vo.height * 0.5 : element.vo.width * 0.5;
			BitmapUtil.drawBitmapDataToGraphics(new load_error, element.graphics, iconSize, iconSize, - iconSize * 0.5, - iconSize * 0.5, true);
			
			element.removeLoading();
			
			element.dispatchEvent(new ElementEvent(ElementEvent.IMAGE_TO_RENDER));
		}
		
		/**
		 */		
		private function imgLoaded(evt:ImgInsertEvent):void
		{
			element.imgVO.sourceData = evt.bitmapData;
			
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED, imgLoaded);
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError);
			imgLoader = null;
			
			element.removeLoading();
			
			element.toNomalState();
		}
		
		
		/**
		 */		
		private var imgLoader:ImgInsertor = new ImgInsertor;
	}
}