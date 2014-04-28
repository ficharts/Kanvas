package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
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
			for (var i:int = 0; i < length; i++)
			{
				CoreFacade.addElement(groupElements[i]);
				if (groupElements[i] is PageElement)
					CoreFacade.coreMediator.pageManager.addPage(groupElements[i].vo as PageVO);
				
				if (groupElements[i].screenshot)
					CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(groupElements[i]);
			}
			
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
			{
				CoreFacade.removeElement(groupElements[i]);
				if (groupElements[i] is PageElement)
					CoreFacade.coreMediator.pageManager.removePage(groupElements[i].vo as PageVO);
			}
			
			CoreFacade.removeElement(newGroup);
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.addElement(newGroup);
			
			for (var i:int = 0; i < length; i++)
			{
				CoreFacade.addElement(groupElements[i]);
				if (groupElements[i] is PageElement)
				{
					var pageVO:PageVO = groupElements[i].vo as PageVO;
					CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageVO.index);
				}
			}
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			sendNotification(Command.SElECT_ELEMENT, newGroup);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var newGroup:GroupElement;
		private var groupElements:Vector.<ElementBase>;
		private var length:int;
		
		private var v:Vector.<PageVO>;
	}
}