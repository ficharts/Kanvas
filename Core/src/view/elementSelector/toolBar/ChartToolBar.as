package view.elementSelector.toolBar
{
	import com.kvs.ui.button.IconBtn;
	
	import flash.events.MouseEvent;
	
	import view.element.chart.ChartElement;
	import view.element.text.TextEditField;

	/**
	 * 
	 * 图表的快捷工具条
	 * 
	 * @author wanglei
	 * 
	 */	
	public class ChartToolBar extends ToolBarBase
	{
		public function ChartToolBar(toolBar:ToolBarController)
		{
			super(toolBar);
			
			editBtn.tips = '编辑';
			
			text_edit;
			toolBar.initBtnStyle(editBtn, 'text_edit');
			
			
			editBtn.addEventListener(MouseEvent.CLICK, editChartHandler, false, 0, true);
		}
		
		/**
		 */		
		private function editChartHandler(evt:MouseEvent):void
		{
			toolBar.selector.coreMdt.editChart(toolBar.selector.element as ChartElement);
		}
		
		/**
		 */		
		private var editBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		override public function render():void
		{
			initPageElementConvertIcons();
			toolBar.addBtn(editBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			toolBar.addBtn(toolBar.delBtn);
		}
	}
}