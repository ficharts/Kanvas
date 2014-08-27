package view.elementSelector.toolBar
{
	/**
	 * 
	 * 透明页面的工具条，这种页面不需要转化元素而来，编辑时可见，阅读时不可见
	 * 
	 * @author wallenMac
	 * 
	 */	
	public final class CameraShape extends ToolBarBase
	{
		public function CameraShape(toolBar:ToolBarController)
		{
			super(toolBar);
		}
		
		/**
		 */		
		override public function render():void
		{
			toolBar.clear();
			
			toolBar.addBtn(toolBar.pageEditBtn);
			toolBar.addBtn(toolBar.zoomBtn);
			toolBar.addBtn(toolBar.delBtn);
		}
	}
}