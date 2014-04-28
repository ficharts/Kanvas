package view.elementSelector.toolBar
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.button.LabelBtnWithTopIcon;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import flash.events.MouseEvent;
	
	import view.element.text.TextEditField;

	/**
	 * 文本的快捷工具条，文本编辑的正式工具条位于文本编辑器中
	 */	
	public class TextShape extends ToolbarWithStyle
	{
		public function TextShape(toolBar:ToolBarController)
		{
			super(toolBar);
			
			
			this.colorIconStyleXML = <states>
											<normal>
												<fill color='${iconColor}' thickness='3'/>
											</normal>
											<hover radius={colorIconSize}>
												<fill color='${iconColor}' thickness='3'/>
											</hover>
											<down radius={colorIconSize}>
												<fill color='${iconColor}' thickness='3'/>
											</down>
										</states>
			
			this.colorPreviewIconStyleXML = <states>
												<normal radius={colorIconSize}>
													<fill color='${iconColor}' thickness='3'/>
												</normal>
												<hover radius={colorIconSize}>
													<fill color='${iconColor}' thickness='3'/>
												</hover>
												<down radius={colorIconSize}>
													<fill color='${iconColor}' thickness='3'/>
												</down>
											</states>
			
			text_edit;
			
			editBtn.tips = '编辑';
			toolBar.initBtnStyle(editBtn, 'text_edit');
			
			addedColorBtn.iconWidth = addedColorBtn.iconHeight = toolBar.iconSize;
			addedColorBtn.w = addedColorBtn.h = toolBar.btnHeight;
			addedColorBtn.bgStatesXML = this.colorBtnBGStyle;
			
			editBtn.addEventListener(MouseEvent.CLICK, editTextHandler, false, 0, true);
		}
		
		/**
		 */		
		override public function init():void
		{
			var styleXML:XML = XMLVOMapper.getStyleXMLBy_ID('text', 'colors') as XML;
			
			//resetColorBtns(styleXML);
		}
		
		/**
		 */		
		override public function stylePanelOpen():void
		{
			if(toolBar.colorBtns.containsKey(toolBar.styleBtn.data))
			{
				toolBar.curStyleBtn = toolBar.colorBtns.getValue(toolBar.styleBtn.data);
			}
			else
			{
				addedColorBtn.iconColor = toolBar.styleBtn.iconColor;
				addedColorBtn.data = toolBar.styleBtn.data;
				toolBar.curStyleBtn = addedColorBtn;
				toolBar.addBtn(toolBar.curStyleBtn);
			}
		}
		
		/**
		 * 附加的颜色按钮，文本的编辑状态和选择状态下工具条中
		 * 
		 * 颜色面板内容不同，选择状态下仅是择取了部分颜色；
		 * 
		 * 编辑状态切换高选择状态时，如果选取的颜色在选择面板中不存在则
		 * 
		 * 补偿一个，并且仅补偿这一个；
		 */		
		public var addedColorBtn:StyleBtn = new StyleBtn();
		
		/**
		 */		
		private function editTextHandler(evt:MouseEvent):void
		{
			(toolBar.selector.element as TextEditField).toEditState();
		}
		
		/**
		 */		
		private var editBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		override public function render():void
		{
			toolBar.addBtn(editBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			initPageElementConvertIcons();
			toolBar.addBtn(toolBar.delBtn);
			this.resetColorIconStyle();
		}
		
	}
}