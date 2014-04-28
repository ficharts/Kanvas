package view.elementSelector.toolBar
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.button.LabelBtnWithTopIcon;
	
	import commands.Command;
	
	import flash.events.MouseEvent;

	/**
	 * 临时组合的工具条
	 */	
	public class TemGroupToolbar extends ToolBarBase
	{
		public function TemGroupToolbar(toolBar:ToolBarController)
		{
			super(toolBar);
			
			group;
			groupBtn.tips = '组合';
			toolBar.initBtnStyle(groupBtn, 'group');
			
			groupBtn.addEventListener(MouseEvent.CLICK, editTextHandler, false, 0, true);
		}
		
		/**
		 */		
		private function editTextHandler(evt:MouseEvent):void
		{
			toolBar.selector.coreMdt.sendNotification(Command.TEM_TO_GROUP);
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