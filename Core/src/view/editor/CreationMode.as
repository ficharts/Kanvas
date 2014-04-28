package view.editor
{
	public class CreationMode extends EditorModeBase
	{
		public function CreationMode(editor:EditorBase)
		{
			super(editor);
		}
		
		/**
		 */		
		override public function close():void
		{
			editor.createElement();			
		}
	}
}