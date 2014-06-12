package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.element.IElement;
	import view.element.PageElement;

	/**
	 */	
	public class PasteGroupCMD extends Command
	{
		public function PasteGroupCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			var pastElement:ElementBase = CoreFacade.coreMediator.getElementForPaste();
			
			if (!pastElement)
				return;
			
			pageElements = new Vector.<ElementBase>;
			
			newGroup = pastElement.clone() as GroupElement;
			
			
			//移动所有元件到新位置--------------------------------------------------------------------------------------
			var dis:Number = CoreFacade.coreMediator.layoutTransformer.stageDisToCanvasDis(10);
			CoreApp.PAST_LOC.x += dis;
			CoreApp.PAST_LOC.y += dis;
			
			newGroup.vo.x = CoreApp.PAST_LOC.x; 
			newGroup.vo.y = CoreApp.PAST_LOC.y;
			
			//复制元素与原始元素坐标差
			var xOff:Number = newGroup.vo.x - pastElement.vo.x;
			var yOff:Number = newGroup.vo.y - pastElement.vo.y;
			
			CoreFacade.coreMediator.checkAutoGroup(newGroup);
			CoreFacade.coreMediator.autoGroupController.moveTo(xOff, yOff, true); 
			
			
			//将所有子元件加入到kanvas中-------------------------------------------------------------------------------
			CoreFacade.addElement(newGroup);
			
			//此时的智能组合囊括了所有子元素
			groupElements = CoreFacade.coreMediator.autoGroupController._elements.concat();
			length = groupElements.length;
			
			var element:ElementBase;
			for (var i:int = 0; i < length; i++)
			{
				element = groupElements[i] as ElementBase;
				CoreFacade.addElement(element);
				
				if (element.isPage)
					pageElements.push(element);
				
				if (element.screenshot)
					CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(element);
			}
			
			pageElements.sort(sortOnPageIndex);
			
			for each (element in pageElements)
				CoreFacade.coreMediator.pageManager.addPage(element.vo.pageVO);
			
			v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
			
			sendNotification(Command.SElECT_ELEMENT, newGroup);
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			for (var i:int = length - 1; i >= 0; i--)
				CoreFacade.removeElement(groupElements[i]);
			
			CoreFacade.removeElement(newGroup);
			
			for each (var element:ElementBase in pageElements)
				CoreFacade.coreMediator.pageManager.removePage(element.vo.pageVO);
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.addElement(newGroup);
			
			for (var i:int = 0; i < length; i++)
				CoreFacade.addElement(groupElements[i]);
			
			for each (var element:ElementBase in pageElements)
				CoreFacade.coreMediator.pageManager.addPage(element.vo.pageVO);
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			sendNotification(Command.SElECT_ELEMENT, newGroup);
			
			this.dataChanged();
		}
		
		private function sortOnPageIndex(a:ElementBase, b:ElementBase):int
		{
			if (a.copyFrom.vo.pageVO.index < b.copyFrom.vo.pageVO.index)
				return -1;
			else if (a.copyFrom.vo.pageVO.index > b.copyFrom.vo.pageVO.index)
				return 1;
			else 
				return 0;
		}
		
		/**
		 */		
		private var newGroup:GroupElement;
		private var groupElements:Vector.<IElement>;
		private var length:int;
		private var pageElements:Vector.<ElementBase>;
		
		
		private var v:Vector.<PageVO>;
	}
}