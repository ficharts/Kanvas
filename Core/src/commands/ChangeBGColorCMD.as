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
			
			setColor(newColorIndex, true);
			
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
		private function setColor(index:uint, exec:Boolean = false):void
		{
			CoreFacade.coreProxy.bgColorIndex = index;
			CoreFacade.coreProxy.updateBgColor();
			
			sendNotification(Command.RENDER_BG_COLOR);
			
			CoreFacade.coreMediator.coreApp.bgColorUpdated(CoreFacade.coreProxy.bgColorIndex);
			
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
		private var oldColorIndex:uint = 0;
		
		private var newColorIndex:uint = 0;
		
		private var v:Vector.<PageVO>;
	}
}