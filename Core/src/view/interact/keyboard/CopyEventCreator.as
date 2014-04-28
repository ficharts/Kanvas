package view.interact.keyboard
{
	import flash.display.Sprite;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.FontLookup;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.edit.ISelectionManager;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	/**
	 * 因IE下无法捕捉到复制粘贴能键盘交互，这里采用一个FTE文本引擎
	 * 
	 * 上的特性，能够触发键盘上的复制快捷指令
	 */	
	public class CopyEventCreator extends Sprite
	{
		public function CopyEventCreator()
		{
			super();
			
			var textLayoutFormat:TextLayoutFormat = new TextLayoutFormat;
			textLayoutFormat.fontFamily = "微软雅黑";
			textLayoutFormat.fontSize = 30;
			textLayoutFormat.fontLookup = FontLookup.DEVICE;
			textLayoutFormat.cffHinting = CFFHinting.NONE;
			
			textManager = new TextContainerManager(this);
			textManager.editingMode = EditingMode.READ_WRITE;
			textManager.hostFormat = textLayoutFormat;
			
			textManager.compositionWidth = 20;
			textManager.compositionHeight = 20;
			textManager.updateContainer();
		}
		
		/**
		 */		
		internal function start():void
		{
			var editM:ISelectionManager = textManager.beginInteraction();
			editM.selectRange(0, 0);
			editM.setFocus();
			
			ifWillDo = true;
		}
		
		/**
		 */		
		internal var ifWillDo:Boolean = false;
		
		/**
		 */		
		internal function end():void
		{
			ifWillDo = false;
		}
		
		/**
		 */		
		private var textManager:TextContainerManager;
	}
}