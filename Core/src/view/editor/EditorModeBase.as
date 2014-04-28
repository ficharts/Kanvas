package view.editor
{
	import view.element.ElementBase;

	/**
	 * 编辑器状态基类， 分创建模式和编辑模式
	 */	
	public class EditorModeBase
	{
		/**
		 */		
		public function EditorModeBase(editor:EditorBase)
		{
			this.editor = editor;
		}
		
		/**
		 * 开启编辑器, 将要编辑的原件传递进来，
		 * 
		 * 如果是创建新原件则不需要传递参数
		 */		
		public function open(element:ElementBase = null):void
		{
			
		}
		
		/**
		 * 关闭编辑器， 创建模式下创建新原件
		 * 
		 * 编辑模式下， 更新当前原件属性及位置
		 */		
		public function close():void
		{
			
		}
		
		/**
		 */		
		protected var editor:EditorBase;
	}
}