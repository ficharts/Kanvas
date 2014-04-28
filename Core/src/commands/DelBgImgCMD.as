package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgInsertor;
	import util.undoRedo.UndoRedoMannager;

	/**
	 */	
	public class DelBgImgCMD extends Command
	{
		public function DelBgImgCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			//ImgLib.unRegister(CoreFacade.coreProxy.bgVO.imgID);
			imgInsertor = CoreFacade.coreProxy.backgroundImageLoader;
			imgInsertor.close();
			
			oldImgObj = {};
			oldImgObj.imgID   = CoreFacade.coreProxy.bgVO.imgID;
			oldImgObj.imgData = CoreFacade.coreProxy.bgVO.imgData;
			oldImgObj.imgURL  = CoreFacade.coreProxy.bgVO.imgURL;
			
			newImgObj = {};
			newImgObj.imgID   = 0;
			newImgObj.imgData = null;
			newImgObj.imgURL  = null;
			
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
		
		private function setBgImg(obj:Object, exec:Boolean = false):void
		{
			//分配背景图片的ID
			CoreFacade.coreProxy.bgVO.imgID   = obj.imgID;
			CoreFacade.coreProxy.bgVO.imgData = obj.imgData;
			CoreFacade.coreProxy.bgVO.imgURL  = obj.imgURL;
			
			CoreFacade.coreMediator.coreApp.drawBGImg(obj.imgData);
			(CoreFacade.coreMediator.coreApp as CoreApp).bgImgUpdated(obj.imgData);
			
			if (exec)
			{
				for each (var vo:PageVO in CoreFacade.coreMediator.pageManager.pages)
					CoreFacade.coreMediator.pageManager.registUpdateThumbVO(vo);
				v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
			}
			else
			{
				CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			}
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var oldImgObj:Object;
		
		/**
		 */		
		private var newImgObj:Object;
		
		private var imgInsertor:ImgInsertor;
		
		private var v:Vector.<PageVO>;
	}
}