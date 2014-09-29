package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	/**
	 * 改变背景颜色
	 */
	public class ChangeBGColorCMD extends Command
	{
		/**
		 */		
		public function ChangeBGColorCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			newColorIndex = uint(notification.getBody());
			
			oldColorIndex = CoreFacade.coreProxy.bgColorIndex;
			
			setColor(newColorIndex);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			setColor(oldColorIndex);
		}
		
		override public function redoHandler():void
		{
			setColor(newColorIndex);
		}
		/**
		 */		
		private function setColor(index:uint):void
		{
			CoreFacade.coreProxy.bgColorIndex = index;
			CoreFacade.coreProxy.updateBgColor();
			
			sendNotification(Command.RENDER_BG_COLOR);
			
			CoreFacade.coreMediator.coreApp.bgColorUpdated(CoreFacade.coreProxy.bgColorIndex, CoreFacade.coreProxy.bgColor);
			CoreFacade.coreMediator.pageManager.updateAllPagesThumb();
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var oldColorIndex:uint = 0;
		
		private var newColorIndex:uint = 0;
	}
}