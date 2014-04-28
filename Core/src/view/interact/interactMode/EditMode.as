package view.interact.interactMode
{
	import commands.Command;
	
	import view.element.ElementBase;
	import view.interact.CoreMediator;
	
	/**
	 * 编辑模式
	 */	
	public class EditMode extends ModeBase
	{
		public function EditMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 */		
		override public function selectAll():void
		{
		}
		
		/**
		 */		
		override public function updateSelector():void
		{
			mainMediator.currentEditor.updateLayout();
		}
		
		/**
		 * 选择和编辑模式下有效
		 */		
		override public function esc():void
		{
			mainMediator.sendNotification(Command.UN_SELECT_ELEMENT);
		}
		
		/**
		 */		
		override public function toUnSelectedMode():void
		{
			mainMediator.enableKeyboardControl();
			mainMediator.currentMode = mainMediator.unSelectedMode;
			mainMediator.closeEditor();
		}
		
		/**
		 */		
		override public function toPrevMode():void
		{
			mainMediator.enableKeyboardControl();
			mainMediator.currentMode = mainMediator.preMode;
			mainMediator.closeEditor();
			
			prevElements();
		}
		
		/**
		 * 单选模式时，取消选择当前元件
		 */		
		override public function unSelectElementDown(element:ElementBase):void
		{
			mainMediator.sendNotification(Command.UN_SELECT_ELEMENT);
			mainMediator.checkAutoGroup(element);
		}
		
		/**
		 * 多选模式下被调用，将当前点击元件添加到临时组合
		 */		
		override public function unSelectElementClicked(element:ElementBase):void
		{
			mainMediator.multiSelectControl.addToTemGroup(element);
		}
		
		/**
		 * 取消选择当前元件
		 */		
		override public function stageBGClicked():void
		{
			mainMediator.sendNotification(Command.UN_SELECT_ELEMENT);
		}
	}
}