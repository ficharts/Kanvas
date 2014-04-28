package commands
{
	import model.CoreFacade;
	import model.vo.ElementVO;
	import model.vo.GroupVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.StyleUtil;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.interact.multiSelect.TemGroupElement;
	import view.ui.Canvas;

	/**
	 * 将临时组合转换为正式的组合
	 */	
	public class GroupCMD extends Command
	{
		public function GroupCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			
			var temGroup:TemGroupElement = CoreFacade.coreMediator.multiSelectControl.temGroupElement;
			var childs:Vector.<ElementBase> = CoreFacade.coreMediator.multiSelectControl.childElements.concat();
			
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			//将临时组合上的属性转换到组合上
			var groupVO:GroupVO = new GroupVO();
			StyleUtil.applyStyleToElement(groupVO, 'group');
			
			groupVO.id = ElementCreator.id;
			groupVO.x = temGroup.vo.x;
			groupVO.y = temGroup.vo.y;
			groupVO.width = temGroup.vo.width;
			groupVO.height = temGroup.vo.height;
			groupVO.scale = temGroup.vo.scale;
			groupVO.rotation = temGroup.vo.rotation;
			
			group = new GroupElement(groupVO);
			group.childElements = childs;
			
			initRoup();
			
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private function initRoup():void
		{
			CoreFacade.addElement(group);
			group.render();
			
			var canvas:Canvas =  CoreFacade.coreMediator.coreApp.canvas;
			var minIndex:uint = canvas.getChildIndex(group);
			var temIndex:uint;
			var childs:Vector.<ElementBase> = group.childElements;
			for each (var element:ElementBase in childs)
			{
				element.toGroupState();
				
				temIndex = canvas.getChildIndex(element);
				minIndex = (temIndex < minIndex) ? temIndex : minIndex;
			}
			
			//将组合原件放到最下方
			CoreFacade.coreMediator.addElementAt(group, minIndex);
			
			CoreFacade.coreMediator.checkAutoGroup(group);
			sendNotification(Command.SElECT_ELEMENT, group);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			var temGroup:TemGroupElement = new TemGroupElement(CoreFacade.coreMediator.multiSelectControl);
			StyleUtil.applyStyleToElement(temGroup.vo, 'tem');
			
			var groupVO:ElementVO = group.vo;
			
			temGroup.vo.x = groupVO.x;
			temGroup.vo.y = groupVO.y;
			temGroup.vo.width = groupVO.width;
			temGroup.vo.height = groupVO.height;
			temGroup.vo.scale = groupVO.scale;
			temGroup.vo.rotation = groupVO.rotation;
			
			for each (var child:ElementBase in group.childElements)
				child.toMultiSelectedState();
			
			CoreFacade.coreMediator.multiSelectControl.temGroupElement = temGroup;
			CoreFacade.coreMediator.multiSelectControl.childElements = group.childElements.concat();
			CoreFacade.coreMediator.multiSelectControl.autoTemGroup();
			CoreFacade.coreMediator.addElement(temGroup);
			
			sendNotification(Command.UN_SELECT_ELEMENT);
			CoreFacade.removeElement(group);
			
			sendNotification(Command.SElECT_ELEMENT, temGroup);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			initRoup();
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var group:GroupElement;
		
		
	}
}