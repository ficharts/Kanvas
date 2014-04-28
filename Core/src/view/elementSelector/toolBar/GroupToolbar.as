package view.elementSelector.toolBar
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.button.LabelBtnWithTopIcon;
	
	import commands.Command;
	
	import flash.events.MouseEvent;

	/**
	 * 临时组合的工具条
	 */	
	public class GroupToolbar extends ToolBarBase
	{
		public function GroupToolbar(toolBar:ToolBarController)
		{
			super(toolBar);
			
			unGroup;
			groupBtn.tips = '解除组合';
			toolBar.initBtnStyle(groupBtn, 'unGroup');
			
			groupBtn.addEventListener(MouseEvent.CLICK, editTextHandler, false, 0, true);
		}
		
		/**
		 */		
		private function editTextHandler(evt:MouseEvent):void
		{
			toolBar.selector.coreMdt.sendNotification(Command.GROUP_TO_TEM);
		}
		
		/**
		 */		
		override public function render():void
		{
			toolBar.addBtn(groupBtn);
			toolBar.addBtn(toolBar.delBtn);
		}
		
		/**
		 */		
		private var groupBtn:IconBtn = new IconBtn;
	}
}