package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;

	public final class ChangePageIndexCMD extends Command
	{
		public function ChangePageIndexCMD()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var obj:Object = notification.getBody();
			pageVO = obj.pageVO;
			oldIndex = obj.oldIndex;
			newIndex = obj.newIndex;
			setIndex(newIndex);
			
			UndoRedoMannager.register(this);
		}
		
		override public function undoHandler():void
		{
			setIndex(oldIndex);
		}
		
		override public function redoHandler():void
		{
			setIndex(newIndex);
		}
		
		private function setIndex(value:int):void
		{
			CoreFacade.coreMediator.pageManager.setPageIndex(pageVO, value, true);
		}
		
		private var oldIndex:int;
		
		private var newIndex:int;
		
		private var pageVO:PageVO;
	}
}