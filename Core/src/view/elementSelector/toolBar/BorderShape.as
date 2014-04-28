package view.elementSelector.toolBar
{
	import com.kvs.ui.button.IconBtn;
	
	import commands.Command;
	
	import flash.events.MouseEvent;

	/**
	 * 边框型图形，不含填充，可控制边框粗细
	 */	
	public class BorderShape extends ToolbarWithStyle
	{
		/**
		 * 线条的最大线粗
		 */		
		public static var MAX_LINE_THICKNESS:uint = 30;
		
		public function BorderShape(toolBar:ToolBarController)
		{
			super(toolBar);
			
			this.colorIconStyleXML = <states>
											<normal>
												<border color='${iconColor}' thickness='3'/>
											</normal>
											<hover radius={colorIconSize}>
												<border color='${iconColor}' thickness='3'/>
											</hover>
											<down radius={colorIconSize}>
												<border color='${iconColor}' thickness='3'/>
											</down>
										</states>
			
			
			this.colorPreviewIconStyleXML = <states>
												<normal radius={colorIconSize}>
													<border color='${iconColor}' thickness='3'/>
												</normal>
												<hover radius={colorIconSize}>
													<border color='${iconColor}' thickness='3'/>
												</hover>
												<down radius={colorIconSize}>
													<border color='${iconColor}' thickness='3'/>
												</down>
											</states>
			
			xi;
			cu;
			
			addBtn.tips = '加粗';
			toolBar.initBtnStyle(addBtn, 'cu');
			addBtn.addEventListener(MouseEvent.CLICK, addHandler, false, 0, true);
			
			cutBtn.tips = '变细';
			toolBar.initBtnStyle(cutBtn, 'xi');
			cutBtn.addEventListener(MouseEvent.CLICK, cutHandler, false, 0, true);
		}
		
		/**
		 */		
		private function addHandler(evt:MouseEvent):void
		{
			if (element.vo.thickness < MAX_LINE_THICKNESS) 
			{
				var oldObj:Object = {};
				oldObj.thickness = element.vo.thickness;
				
				element.vo.thickness *= 1.1;
				element.render();
				
				toolBar.selector.layoutInfo.update();
				toolBar.selector.render();
				
				toolBar.selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldObj);
			}
		}
		
		/**
		 */		
		private function cutHandler(evt:MouseEvent):void
		{
			if (element.vo.thickness > 1) 
			{
				var oldObj:Object = {};
				oldObj.thickness = element.vo.thickness;
				
				element.vo.thickness --;
				//element.vo.thickness -= 1/toolBar.selector.coreMdt.canvas.scaleX;
				
				element.render();
				
				toolBar.selector.layoutInfo.update();
				toolBar.selector.render();
				
				toolBar.selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldObj);
			}
		}
		
		/**
		 */		
		protected var addBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		protected var cutBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		override public function render():void
		{
			toolBar.clear();
			toolBar.addBtn(toolBar.styleBtn);
			toolBar.addBtn(addBtn);
			toolBar.addBtn(cutBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			initPageElementConvertIcons();
			toolBar.addBtn(toolBar.delBtn);
			
			resetColorIconStyle();
			
		}
		
	}
}