package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.Camera;
	import view.element.ElementBase;
	import view.element.PageElement;
	
	/**
	 * 粘贴元素
	 */
	public class PasteElementCMD extends Command
	{
		/**
		 */		
		public function PasteElementCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			var pastElement:ElementBase = CoreFacade.coreMediator.getElementForPaste();
			
			if(!pastElement) return;
			
			element = pastElement.clone();
			
			// 为新元素创建，添加偏移
			var dis:Number = CoreFacade.coreMediator.layoutTransformer.stageDisToCanvasDis(10);
			CoreApp.PAST_LOC.x += dis;
			CoreApp.PAST_LOC.y += dis;
			
			element.vo.x = CoreApp.PAST_LOC.x; 
			element.vo.y = CoreApp.PAST_LOC.y;
			
			//复制元素与原始元素坐标差
			var xOff:Number = element.vo.x - pastElement.vo.x;
			var yOff:Number = element.vo.y - pastElement.vo.y;
			
			(element is Camera) ? CoreFacade.addElementAt(element, 1) : CoreFacade.addElement(element);
			if (element is PageElement)
				CoreFacade.coreMediator.pageManager.addPage(element.vo as PageVO);
			elementIndex = element.index;
			
			if (element.screenshot)
				CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(element);
			
			autoGroupEnabled = CoreFacade.coreMediator.autoGroupController.enabled;
			if (autoGroupEnabled)
			{
				elementIndexArray = [];
				CoreFacade.coreMediator.autoGroupController.pastElements(xOff, yOff);
				groupElements = CoreFacade.coreMediator.autoGroupController.elements.concat();
				length = groupElements.length;
				for (var i:int = 0; i < length; i++)
				{
					if (groupElements[i] is PageElement)
						CoreFacade.coreMediator.pageManager.addPage(groupElements[i].vo as PageVO);
					if (groupElements[i].screenshot)
						CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(groupElements[i]);
				}
			}
			
			v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
			
			sendNotification(Command.SElECT_ELEMENT, element);
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			if (autoGroupEnabled)
			{
				for (var i:int = length - 1; i >= 0; i--)
				{
					elementIndexArray[i] = groupElements[i].index;
					CoreFacade.removeElement(groupElements[i]);
					if (groupElements[i] is PageElement)
						CoreFacade.coreMediator.pageManager.removePage(groupElements[i].vo as PageVO);
				}
			}
			
			CoreFacade.removeElement(element);
			if (element is PageElement)
				CoreFacade.coreMediator.pageManager.removePage(element.vo as PageVO);
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.addElementAt(element, elementIndex);
			if (element is PageElement)
			{
				var pageVO:PageVO = element.vo as PageVO;
				CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageVO.index);
			}
			if (autoGroupEnabled)
			{
				for (var i:int = 0; i < length; i++)
				{
					CoreFacade.addElementAt(groupElements[i], elementIndexArray[i]);
					if (groupElements[i] is PageElement)
					{
						pageVO = groupElements[i].vo as PageVO;
						CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageVO.index);
					}
				}
			}
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var groupElements:Vector.<ElementBase>;
		private var length:int;
		private var elementIndexArray:Array;
		
		private var elementIndex:int;
		
		/**
		 */		
		private var element:ElementBase;
		
		private var autoGroupEnabled:Boolean;
		
		private var v:Vector.<PageVO>;
	}
}