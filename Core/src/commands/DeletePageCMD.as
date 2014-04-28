package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.PageElement;

	/**
	 */	
	public final class DeletePageCMD extends Command
	{
		public function DeletePageCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			page = notification.getBody() as PageElement;
			pageVO = page.vo as PageVO;
			index1 = CoreFacade.getElementIndex(page);
			index2 = (page.vo as PageVO).index;
			
			CoreFacade.removeElement(page);
			CoreFacade.coreMediator.pageManager.removePage(pageVO);
			
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		override public function undoHandler():void
		{
			CoreFacade.addElementAt(page, index1);
			CoreFacade.coreMediator.pageManager.addPageAt(pageVO, index2);
			
			this.dataChanged();
		}
		
		override public function redoHandler():void
		{
			CoreFacade.removeElement(page);
			CoreFacade.coreMediator.pageManager.removePage(pageVO);
			
			this.dataChanged();
		}
		
		private var page:PageElement;
		private var pageVO:PageVO;
		
		private var index1:int;
		private var index2:int;
	}
}