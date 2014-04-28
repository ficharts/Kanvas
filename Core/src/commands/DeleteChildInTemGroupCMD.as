package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.PageElement;
	
	/**
	 * 删除临时组合里的子元素
	 */	
	public class DeleteChildInTemGroupCMD extends Command
	{
		public function DeleteChildInTemGroupCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			groupElements = CoreFacade.coreMediator.autoGroupController.elements;
			groupElementIndexs = new Vector.<int>;
			
			groupLength = groupElements.length;
			
			for (var i:int = 0; i < groupLength; i++)
			{
				var item:ElementBase = groupElements[i];
				if (item is PageElement)
					CoreFacade.coreMediator.pageManager.removePage(item.vo as PageVO);
				else
					CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(item);
				groupElementIndexs[i] = item.index;
				CoreFacade.removeElement(item);
			}
			
			v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			for (var i:int = groupLength - 1; i >= 0; i--)
			{
				var item:ElementBase = groupElements[i];
				CoreFacade.addElementAt(item, groupElementIndexs[i]);
				if (item is PageElement)
				{
					var pageVO:PageVO = item.vo as PageVO;
					CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageVO.index);
				}
			}
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			for each (var item:ElementBase in groupElements)
			{
				CoreFacade.removeElement(item);
				if (item is PageElement)
					CoreFacade.coreMediator.pageManager.removePage(item.vo as PageVO);
			}
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var shape:ElementBase;
		
		/**
		 */		
		private var groupElements:Vector.<ElementBase>;
		private var groupElementIndexs:Vector.<int>;
		private var groupLength:int;
		
		private var v:Vector.<PageVO>;
	}
}