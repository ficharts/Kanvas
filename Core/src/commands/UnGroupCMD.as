package commands
{
	import model.CoreFacade;
	import model.vo.ElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.StyleUtil;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.interact.multiSelect.TemGroupElement;

	/**
	 * 解除组合
	 */	
	public class UnGroupCMD extends Command
	{
		public function UnGroupCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			group = CoreFacade.coreMediator.currentElement as GroupElement;
			temGroup = new TemGroupElement(CoreFacade.coreMediator.multiSelectControl);
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
			
			
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var group:GroupElement;
		
		/**
		 */		
		private var temGroup:TemGroupElement;
		
		/**
		 */		
		override public function undoHandler():void
		{
			var temGroup:TemGroupElement = CoreFacade.coreMediator.multiSelectControl.temGroupElement;
			var childs:Vector.<ElementBase> = CoreFacade.coreMediator.multiSelectControl.childElements.concat();
			
			for each (var element:ElementBase in childs)
				element.toGroupState();
			
			sendNotification(Command.UN_SELECT_ELEMENT);
			CoreFacade.addElement(group);
			group.render();
			
			CoreFacade.coreMediator.checkAutoGroup(group);
			sendNotification(Command.SElECT_ELEMENT, group);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
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
	}
}