package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.StyleUtil;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.IElement;
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
			
			var xOff:Number;
			var yOff:Number;
			
			var pastElement:ElementBase = CoreFacade.coreMediator.getElementForPaste();
			
			if(!pastElement) return;
			
			pageElements = new Vector.<ElementBase>;
			
			element = pastElement.clone();
			
			// 为新元素创建，添加偏移
			var dis:Number = CoreFacade.coreMediator.layoutTransformer.stageDisToCanvasDis(10);
			CoreApp.PAST_LOC.x += dis;
			CoreApp.PAST_LOC.y += dis;
			
			element.vo.x = CoreApp.PAST_LOC.x; 
			element.vo.y = CoreApp.PAST_LOC.y;
			
			
			//复制元素与原始元素坐标差
			xOff = element.vo.x - pastElement.vo.x;
			yOff = element.vo.y - pastElement.vo.y;
			
			StyleUtil.applyStyleToElement(element.vo);
			CoreFacade.addElement(element);
			
			if (element.isPage) 
				pageElements.push(element);
			
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
				
				var ele:ElementBase;
				for (var i:int = 0; i < length; i++)
				{
					ele = groupElements[i] as ElementBase;
					
					if (ele.isPage)
						pageElements.push(ele);
					
					if (ele.screenshot)
						CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(ele);
				}
			}
			
			pageElements.sort(sortOnPageIndex);
			
			for each (ele in pageElements)
				CoreFacade.coreMediator.pageManager.addPage(element.vo.pageVO);
			
			if (pageElements.length)
				CoreFacade.coreMediator.pageManager.layoutPages();
				
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
					elementIndexArray[i] = (groupElements[i] as ElementBase).index;
					CoreFacade.removeElement(groupElements[i]);
				}
			}
			
			CoreFacade.removeElement(element);
			
			for each (var element:ElementBase in pageElements)
				CoreFacade.coreMediator.pageManager.removePage(element.vo.pageVO);
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.addElementAt(element, elementIndex);
			
			if (autoGroupEnabled)
			{
				for (var i:int = 0; i < length; i++)
					CoreFacade.addElementAt(groupElements[i], elementIndexArray[i]);
			}
			
			for each (var element:ElementBase in pageElements)
				CoreFacade.coreMediator.pageManager.addPage(element.vo.pageVO);
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			
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
		private var groupElements:Vector.<IElement>;
		private var length:int;
		private var pageElements:Vector.<ElementBase>;
		private var elementIndexArray:Array;
		
		private var elementIndex:int;
		
		/**
		 */		
		private var element:ElementBase;
		
		private var autoGroupEnabled:Boolean;
		
		private var v:Vector.<PageVO>;
	}
}