package
{
	import com.kvs.ui.Panel;
	import com.kvs.ui.toolTips.ToolTipsManager;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.App;
	
	import control.NavControl;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import view.chartPanel.ChartPanel;
	import view.element.chart.Chart2D;
	import view.pagePanel.PagePanel;
	import view.shapePanel.ShapePanel;
	import view.templatePanel.TemplatePanel;
	import view.themePanel.ThemePanel;
	import view.toolBar.ToolBar;
	import view.toolBar.ZoomToolBar;
	
	/**
	 * kanvas的主UI，包含工具条，页面与图形创建面板
	 */	
	public class Kanvas extends App
	{
		public function Kanvas()
		{
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */		
		protected function init():void
		{
			this.setLib();
			
			toolBar = new ToolBar(this);
			
			kvsCore.externalUI = uiContainer;
			kvsCore.addEventListener(KVSEvent.READY, kvsReadyHandler);
			kvsCore.addEventListener(KVSEvent.TO_PAGE_EDIT, toPageEditMode);
			kvsCore.addEventListener(KVSEvent.CANCEL_PAGE_EDIT, cancelPageEdit);
			kvsCore.addEventListener(KVSEvent.CONFIRM_PAGE_EDIT, confirmPageEdit);
			kvsCore.addEventListener(KVSEvent.IMPORT_DATA_COMPLETE, importDataComplete);
			
			kvsCore.addEventListener(KVSEvent.TOOLBAR_TO_CHART, toChartEdit);
			
			addChild(kvsCore);
			addChild(uiContainer);
			
			initPanels();
			uiContainer.addChild(zoomToolBar);//zoombar在这里加载是为了防止布局时因为zoombar没有初始化导致的位置偏差
			
			//UI交互控制
			mainNavControl = new NavControl(this);
			
			preLayout();
			
			uiContainer.addChild(chartPanel);
			uiContainer.addChild(pagePanel);
			uiContainer.addChild(themePanel);
			uiContainer.addChild(shapePanel);
			uiContainer.addChild(toolBar);
			uiContainer.addChild(templatePanel);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
			
			// 工具提示初始化
			toolTipsManager = new ToolTipsManager(this);
			toolTipsManager.setStyleXML(tipsStyle);
			
			// 核心core开始初始化
			kvsCore.startInit();
			
			if (CoreFacade.coreMediator.zoomMoveControl)
				zoomToolBar.controller = CoreFacade.coreMediator.zoomMoveControl;
		}
		
		/**
		 */		
		private function toPageEditMode(evt:KVSEvent):void
		{
			evt.stopPropagation();
			mainNavControl.toPageEditMode();
		}
		
		/**
		 */		
		private function cancelPageEdit(evt:KVSEvent):void
		{
			evt.stopPropagation();
			mainNavControl.cancelPageEdit();
		}
		
		/**
		 */		
		private function confirmPageEdit(evt:KVSEvent):void
		{
			evt.stopPropagation();
			mainNavControl.confirmPageEdit();
		}
		
		/**
		 */		
		private function toChartEdit(evt:KVSEvent):void
		{
			evt.stopPropagation();
			
			
		}
		
		/**
		 */		
		private function importDataComplete(evt:KVSEvent):void
		{
			evt.stopPropagation();
			
			closeTemplatePanel();
		}
		
		/**
		 */		
		public function closeTemplatePanel():void
		{
			if (templatePanel && templatePanel.visible)
				templatePanel.close(stage.stageWidth * .5, stage.stageHeight * .5 + 10);
		}
		
		/**
		 */		
		private function initPanels():void
		{
			exitIcon;
			
			// 图表面板初始化
			chartPanel = new ChartPanel(this);
			chartPanel.w = 130;
			chartPanel.title = '图表';
			chartPanel.ifShowExitBtn = true;
			chartPanel.isOpen = false;
			chartPanel.bgStyleXML = panelBGStyleXML;
			chartPanel.titleStyleXML = panelTitleStyleXML;
			chartPanel.exitBtnStyleXML = exitBtnStyle;
			
			// 图形面板初始化
			shapePanel = new ShapePanel(this);
			shapePanel.w = 130;
			shapePanel.title = '图形';
			shapePanel.ifShowExitBtn = true;
			shapePanel.isOpen = false;
			shapePanel.bgStyleXML = panelBGStyleXML;
			shapePanel.titleStyleXML = panelTitleStyleXML;
			shapePanel.exitBtnStyleXML = exitBtnStyle;
			
			// 样式面板初始化
			themePanel = new ThemePanel(this);
			themePanel.w = 130;
			themePanel.barHeight = 40;
			themePanel.title = '主题';
			themePanel.ifShowExitBtn = true;
			themePanel.isOpen = false;
			themePanel.bgStyleXML = panelBGStyleXML;
			themePanel.titleStyleXML = panelTitleStyleXML;
			themePanel.exitBtnStyleXML = exitBtnStyle;
			
			//多页面列表
			pagePanel = new PagePanel(this);
			pagePanel.bgStyleXML = panelBGStyleXML;
			
			//模板
			templatePanel = new TemplatePanel(this);
			templatePanel.bgStyleXML = <style>
									<border color='#eeeeee' alpha='1'/>
									<fill color='#eeeeee' alpha='1'/>
								 </style>;;
			templatePanel.titleStyleXML = panelTitleStyleXML;
		}
		
		/**
		 */		
		protected function stageResizeHandler(evt:Event):void
		{
			if (stage.stageWidth && stage.stageHeight)
			{
				preLayout();
				
				toolBar.updateLayout();
				chartPanel.updateLayout();
				shapePanel.updateLayout();
				themePanel.updateLayout();
				pagePanel.updateLayout();
				templatePanel.updateLayout();
				
				kvsCore.resize();
			}
		}
		
		/**
		 * 设置工具条，创建面板的尺寸/布局关系
		 */		
		private function preLayout():void
		{
			toolBar.w = stage.stageWidth;
			toolBar.h = 50;
			
			chartPanel.h = pagePanel.h = shapePanel.h = themePanel.h = stage.stageHeight - toolBar.h;
			chartPanel.y = pagePanel.y = shapePanel.y = themePanel.y = toolBar.h;
			
			zoomToolBar.y = (stage.stageHeight - zoomToolBar.height) * .5;
			mainNavControl.alginToRight();
			
			//画布尺寸变化时调用此方法
			updateKvsContenBound();
		}
		
		
		/**
		 * 尺寸缩放，面板开始／关闭时，更新画布内容区域，此区域作为画布内容自适应，内容范围检测等事务
		 */		
		public function updateKvsContenBound():void
		{
			// 给画布流内容留一定的边距
			var gutter:uint;
			
			if (stage.displayState == StageDisplayState.FULL_SCREEN || 
				stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
			{
				gutter = 5;
				kvsCore.autofitRect = new Rectangle(gutter, gutter, stage.stageWidth - gutter * 2, stage.stageHeight - gutter * 2);
			}
			else
			{
				gutter = 30;
				
				var w:Number =  stage.stageWidth - gutter * 2 - pagePanel.w;
				w -= mainNavControl.rightPanelWidth;
				
				kvsCore.autofitRect = new Rectangle(pagePanel.w + gutter, toolBar.h + gutter, w, 
					stage.stageHeight - toolBar.h - gutter * 2);
			}
			
			kvsCore.contentRect = new Rectangle(0, toolBar.h, stage.stageWidth, stage.stageHeight - toolBar.h);
		}
		
		/**
		 * 核心core初始化完毕
		 */		
		protected function kvsReadyHandler(evt:KVSEvent):void
		{
			kvsCore.changeTheme('style_1', false);
			
			pagePanel.initPageManager();
		}
		
		/**
		 * web版与桌面版的接口不同
		 */		
		public var api:KanvasAPI;
		
		/**
		 * 装载工具条，面板的容器
		 */		
		private var uiContainer:Sprite = new Sprite;
		
		/**
		 */		
		public var chartPanel:Panel;
		
		/**
		 * 图形面板，从这里创建图形元素 
		 */		
		public var shapePanel:Panel;
		
		/**
		 * 全局样式控制面板 
		 */		
		public var themePanel:Panel;
		
		/**
		 */		
		public var pagePanel:PagePanel;
		
		/**
		 */		
		public var templatePanel:TemplatePanel;
		
		/**
		 * 工具条
		 */		
		public var toolBar:ToolBar;
		
		/**
		 * zoom工具条
		 */
		public var zoomToolBar:ZoomToolBar = new ZoomToolBar;
		
		/**
		 * Kanvas的核心内核， 负责基本图文绘制和整体图形机制
		 */		
		public var kvsCore:CoreApp = new CoreApp;
		
		/**
		 * 主场景交互控制 
		 */		
		public var mainNavControl:NavControl;
		
		/**
		 * 工具提示控制器
		 */		
		public var toolTipsManager:ToolTipsManager;
		
		
		
		
		
		//-------------------------------------------------
		//
		// 公共样式及配置
		//
		//-------------------------------------------------
		
		
		/**
		 * 图形创建面板和样式面板中退出按钮的样式 
		 */		
		private var exitBtnStyle:XML = <states>
											   <normal width='30' height='30' radius='30'>
												   <fill color='#333333' alpha='0'/>
												   <img classPath='exitIcon' width='20' height='20'/>
											   </normal>
											   <hover width='30' height='30' radius='30'>
												   <border color='#999999' alpha='1' thickness='1'/>
												   <fill alpha='0'/>
												   <img classPath='exitIcon' width='20' height='20'/>
											   </hover>
											   <down width='30' height='30' radius='30'>
												   <border color='#666666' alpha='1' thickness='2'/>
												   <fill alpha='0'/>
												   <img classPath='exitIcon' width='20' height='20'/>
											   </down>
										   </states>
		/**
		 * 工具提示的样式 
		 */			 
		private var tipsStyle:XML = <label hPadding='12' vPadding='8' radius='30' vMargin='10' hMargin='20'>
										<border thikness='1' alpha='0' color='555555' pixelHinting='true'/>
										<fill color='e96565' alpha='0.9'/>
										<format font='微软雅黑' size='13' color='ffffff'/>
										<text value='${tips}'>
											<effects>
												<shadow color='0' alpha='0.3' distance='1' blur='1' angle='90'/>
											</effects>
										</text>
									</label>;
		
		
		/**
		 * 面板样式
		 */		
		private var panelBGStyleXML:XML = <style>
									<border color='#eeeeee' alpha='1'/>
									<fill color='#eeeeee' alpha='0.8'/>
								 </style>;
		
		private var panelTitleStyleXML:XML = 
			<label radius='0' vPadding='20' hPadding='20'>
				<format color='#555555' font='微软雅黑' size='14'/>
			</label>;
	}
}