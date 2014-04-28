package view.editor
{
	import view.element.ElementBase;

	/**
	 * 编辑模式
	 */	
	public class EditMode extends EditorModeBase
	{
		public function EditMode(editor:EditorBase)
		{
			super(editor);
		}
		
		/**
		 */		
		override public function open(element:ElementBase = null):void
		{
			this.element = element;
		}
		
		/**
		 */		
		override public function close():void
		{
			editor.updateElementAfterEdit();
		}
		
		/**
		 */		
		public var element:ElementBase;
	}
}