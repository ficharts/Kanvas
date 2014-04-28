package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	import util.img.ImgLib;
	import util.undoRedo.UndoRedoMannager;

	/**
	 */	
	public class ChangeBgImgCMD extends ChangeBgImgBase
	{
		public function ChangeBgImgCMD()
		{
			super();
		}
		
		/**
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			try {
				handler = notification.getBody() as Function;
			}
			catch(e:Error)
			{
				
			}
			
			//如果存在已有图片，则先删除已有
			/*if(CoreFacade.coreProxy.bgVO.imgURL)
				sendNotification(Command.DELETE_BG_IMG);*/
			
			imgID = ImgLib.imgID;
			
			imgInsertor = CoreFacade.coreProxy.backgroundImageLoader;
			imgInsertor.addEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLocalHandler);
			imgInsertor.insert(imgID);
		}
		
		private function imgLocalHandler(evt:ImgInsertEvent):void
		{
			imgInsertor.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLocalHandler);
			if (imgInsertor.chooseSameImage)
			{
				ImgLib.unRegister(imgID);
			}
			else
			{
				imgInsertor.addEventListener(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, imgLoadedHandler, false, 0, true);
				if (handler != null)
				{
					handler();
					handler = null;
				}
			}
		}
		
		/**
		 * 图片上传成功才会调用此方法
		 */		
		private function imgLoadedHandler(evt:ImgInsertEvent):void
		{
			imgInsertor.removeEventListener(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, imgLoadedHandler);
			
			oldImgObj = {};
			oldImgObj.imgID   = CoreFacade.coreProxy.bgVO.imgID;
			oldImgObj.imgData = CoreFacade.coreProxy.bgVO.imgData;
			oldImgObj.imgURL  = CoreFacade.coreProxy.bgVO.imgURL;
			
			newImgObj = {};
			newImgObj.imgID   = evt.imgID;
			newImgObj.imgData = evt.bitmapData;
			newImgObj.imgURL  = evt.imgURL;
			
			//CoreFacade.coreMediator.mainUI.canvas.hideLoading();
			
			setBgImg(newImgObj, true);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			setBgImg(oldImgObj);
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			setBgImg(newImgObj);
		}
		
		
		private var handler:Function;
		
		
		/**
		 */		
		private var imgInsertor:ImgInsertor;
		
		private var imgID:uint;
		
		private var v:Vector.<PageVO>;
	}
}