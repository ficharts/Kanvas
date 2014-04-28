package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.StyleUtil;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	public final class ConvertElement2PageCMD extends Command
	{
		public function ConvertElement2PageCMD()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			element = notification.getBody() as ElementBase;
			
			pageVO = new PageVO;
			pageVO.index = CoreFacade.coreMediator.pageManager.index + 1;
			pageVO.styleType = "shape";
			StyleUtil.applyStyleToElement(pageVO, "Page");
			
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
				CoreFacade.coreMediator.pageManager.removePage(pageVO);
				element.setPage(null);
			}
			else
			{
				element.setPage(pageVO);
				CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageVO.index);
			}
			CoreFacade.coreMediator.selector.toolBar.resetToolbar();
		}
		
		private var element:ElementBase;
		
		private var pageVO:PageVO;
	}
}