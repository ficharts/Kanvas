package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;

	/**
	 * 
	 */	
	public class ChangeBgImgBase extends Command
	{
		public function ChangeBgImgBase()
		{
			super();
		}
		/**
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
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
		
		/**
		 */		
		protected function setBgImg(obj:Object):void
		{
			//分配背景图片的ID
			CoreFacade.coreProxy.bgVO.imgID   = obj.imgID;
			CoreFacade.coreProxy.bgVO.imgData = obj.imgData;
			CoreFacade.coreProxy.bgVO.imgURL  = obj.imgURL;
			
			CoreFacade.coreMediator.coreApp.drawBGImg(obj.imgData);
			(CoreFacade.coreMediator.coreApp as CoreApp).bgImgUpdated(obj.imgData);
			
			CoreFacade.coreMediator.pageManager.updateAllPagesThumb();
			
			this.dataChanged();
		}
		
		/**
		 */		
		protected var oldImgObj:Object;
		
		/**
		 */		
		protected var newImgObj:Object;
		
	}
}