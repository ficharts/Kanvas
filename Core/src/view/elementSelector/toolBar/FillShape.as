package view.elementSelector.toolBar
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;

	/**
	 */	
	public class FillShape extends ToolbarWithStyle
	{
		public function FillShape(toolBar:ToolBarController)
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
			
		}
		
		/**
		 */		
		override public function render():void
		{
			toolBar.clear();
			toolBar.addBtn(toolBar.styleBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			initPageElementConvertIcons();
			toolBar.addBtn(toolBar.delBtn);
			resetColorIconStyle();
		}
	}
}