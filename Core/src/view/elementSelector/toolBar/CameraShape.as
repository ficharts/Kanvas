package view.elementSelector.toolBar
{
	import com.kvs.ui.button.IconBtn;
	
	import flash.events.MouseEvent;
	
	import model.vo.PageVO;
	
	import modules.pages.PageUtil;
	import modules.pages.Scene;
	
	import view.elementSelector.ElementSelector;

	/**
	 * 
	 * 页面
	 * 
	 * @author wallenMac
	 * 
	 */	
	public final class CameraShape extends ToolBarBase
	{
		public function CameraShape(toolBar:ToolBarController)
		{
			super(toolBar);
			
			new zoom;
			zoomBtn.tips = '镜头缩放';
			toolBar.initBtnStyle(zoomBtn, 'zoom');
			zoomBtn.addEventListener(MouseEvent.CLICK, zoomHandler, false, 0, true);
		}
		
		private function zoomHandler(evt:MouseEvent):void
		{
			var selector:ElementSelector = toolBar.selector;
			selector.coreMdt.zoomMoveControl.zoomElement(selector.element.vo as PageVO);
			selector.coreMdt.toUnSelectedMode();
		}
		
		private var zoomBtn:IconBtn = new IconBtn;
		
		override public function render():void
		{
			toolBar.clear();
			toolBar.addBtn(zoomBtn);
			initPageElementConvertIcons();
			toolBar.addBtn(toolBar.delBtn);
		}
	}
}