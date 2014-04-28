package commands
{
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	import util.img.ImgLib;
	
	
	/**
	 * 插入图片
	 */
	public class InserImageCMD extends InsertImgCMDBase
	{
		/**
		 */		
		public function InserImageCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			imgInsertor.addEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoadedHandler);
			
			//分配图片ID，选择并上传图片
			imgInsertor.insert(ImgLib.imgID);
		}
		
		/**
		 */		
		private function imgLoadedHandler(evt:ImgInsertEvent):void
		{
			imgInsertor.addEventListener(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, imgUploadComplete);
			
			imgInsertor.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoadedHandler);
			
			createImg(evt.bitmapData, evt.imgID);
		}
		
		
		/**
		 */		
		private function imgUploadComplete(evt:ImgInsertEvent):void
		{
			imgInsertor.removeEventListener(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, imgUploadComplete);
			
			element.imgVO.url = evt.imgURL;
			element.toNomalState();
		}
		
		/**
		 */		
		private var imgInsertor:ImgInsertor = new ImgInsertor;
	}
}