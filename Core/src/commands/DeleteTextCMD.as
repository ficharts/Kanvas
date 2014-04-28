package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.text.TextEditField;

	/**
	 * 删除文本
	 */	
	public class DeleteTextCMD extends Command
	{
		public function DeleteTextCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			element = notification.getBody() as TextEditField;
			elementIndex = CoreFacade.getElementIndex(element);
			CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(element);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.removePage(element.vo.pageVO);
			CoreFacade.removeElement(element);
			v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
			
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.addElementAt(element, elementIndex);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.addPageAt(element.vo.pageVO, element.vo.pageVO.index);
			// 文本被删除时可能处于编辑状态， 所以撤销后需要重绘一下
			// 编辑状态的文本看不到，本身没有绘制
			element.render();
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		override public function redoHandler():void
		{
			CoreFacade.removeElement(element);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.removePage(element.vo.pageVO);
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var element:TextEditField;
		
		private var elementIndex:int;
		
		private var v:Vector.<PageVO>;
	}
}