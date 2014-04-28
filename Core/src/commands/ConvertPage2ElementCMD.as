package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	public final class ConvertPage2ElementCMD extends Command
	{
		public function ConvertPage2ElementCMD()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			element = notification.getBody() as ElementBase;
			
			pageVO = element.vo.pageVO;
			
			convert();
			
			UndoRedoMannager.register(this);
		}
		
		override public function undoHandler():void
		{
			convert(true);
		}
		
		override public function redoHandler():void
		{
			convert();
		}
		
		private function convert(reverse:Boolean = false):void
		{
			if (reverse)
			{
				element.setPage(pageVO);
				CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageVO.index);
			}
			else
			{
				CoreFacade.coreMediator.pageManager.removePage(pageVO);
				element.setPage(null);
			}
			CoreFacade.coreMediator.selector.toolBar.resetToolbar();
		}
		
		
		private var element:ElementBase;
		private var pageVO:PageVO;
	}
}