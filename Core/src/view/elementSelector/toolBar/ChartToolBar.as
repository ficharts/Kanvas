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
			
			editBtn.tips = '编辑数据';
			
			text_edit;
			toolBar.initBtnStyle(editBtn, 'text_edit', btnBGStyle);
			
			
			editBtn.addEventListener(MouseEvent.CLICK, editChartHandler, false, 0, true);
		}
		
		
		/**
		 */		
		private function editChartHandler(evt:MouseEvent):void
		{
			toolBar.selector.coreMdt.toChartEditMode();
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
		
		/**
		 * 图表编辑按钮的颜色要突出一些
		 */			
		public var btnBGStyle:XML = <states>
										<normal>
											<border thickness='1' alpha='1' color='#373737'/>
											<fill color='#6498e8, #447bd8' alpha='1, 1' angle='90'/>
											<img/>
										</normal>
										<hover>
											<border thickness='1' color='000000'/>
											<fill color='#6498e8, #6498e8' alpha='1, 1' angle='90'/>
											<img/>
										</hover>
										<down>
											<border thickness='1' color='000000'/>
											<fill color='#5282cc, #3b68b9' alpha='1, 1' angle='90'/>
											<img/>
										</down>
									</states>
	}
}