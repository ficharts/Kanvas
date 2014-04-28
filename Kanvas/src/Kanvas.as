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
	
	import view.pagePanel.PagePanel;
	import view.shapePanel.ShapePanel;
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
			this.resetLib();
			
			kvsCore.externalUI = uiContainer;
			kvsCore.addEventListener(KVSEvent.READY, kvsReadyHandler);
		
			addChild(kvsCore);
			addChild(uiContainer);
			
			initPanels();
			uiContainer.addChild(zoomToolBar);//zoombar在这里加载是为了防止布局时因为zoombar没有初始化导致的位置偏差
			preLayout();
			
			uiContainer.addChild(pagePanel);
			uiContainer.addChild(themePanel);
			uiContainer.addChild(shapePanel);
			uiContainer.addChild(toolBar);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
			
			// 工具提示初始化
			toolTipsManager = new ToolTipsManager(this);
			toolTipsManager.setStyleXML(tipsStyle);
			
			//UI交互控制
			mainNavControl = new NavControl(this);
			
			// 核心core开始初始化
			kvsCore.startInit();
			
			if (CoreFacade.coreMediator.zoomMoveControl)
				zoomToolBar.controller = CoreFacade.coreMediator.zoomMoveControl;
		}
		
		
		/**
		 */		
		private function initPanels():void
		{
			exitIcon;
			
			// 图形面板初始化
			shapePanel = new ShapePanel(this);
			shapePanel.w = 130;
			shapePanel.title = '图形创建';
			shapePanel.ifShowExitBtn = true;
			shapePanel.isOpen = false;
			shapePanel.bgStyleXML = panelBGStyleXML;
			shapePanel.titleStyleXML = panelTitleStyleXML;
			shapePanel.exitBtnStyleXML = exitBtnStyle;
			
			// 样式面板初始化
			themePanel = new ThemePanel(this);
			themePanel.w = 130;
			themePanel.barHeight = 40;
			themePanel.title = '风格样式';
			themePanel.ifShowExitBtn = true;
			themePanel.isOpen = false;
			themePanel.bgStyleXML = panelBGStyleXML;
			themePanel.titleStyleXML = panelTitleStyleXML;
			themePanel.exitBtnStyleXML = exitBtnStyle;
			
			//多页面列表
			pagePanel = new PagePanel(this);
			pagePanel.bgStyleXML = panelBGStyleXML;
		}
		
		/**
		 */		
		protected function stageResizeHandler(evt:Event):void
		{
			if (stage.stageWidth && stage.stageHeight)
			{
				preLayout();
				
				toolBar.updateLayout();
				shapePanel.updateLayout();
				themePanel.updateLayout();
				pagePanel.updateLayout();
				
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
			
			pagePanel.h = shapePanel.h = themePanel.h = stage.stageHeight - toolBar.h;
			pagePanel.y = shapePanel.y = themePanel.y = toolBar.h;
			
			zoomToolBar.y = (stage.stageHeight - zoomToolBar.height) * .5;
			
			//面板关闭时，将其移至屏幕外右侧，面板开启时，将其移至屏幕内右侧；
			if (themePanel.isOpen)
			{
				themePanel.x = stage.stageWidth - themePanel.w;
				shapePanel.x = stage.stageWidth;
				
				zoomToolBar.x = stage.stageWidth - themePanel.w - zoomToolBar.width - 20;
			}
			else if (shapePanel.isOpen)
			{
				shapePanel.x = stage.stageWidth - shapePanel.w;
				themePanel.x = stage.stageWidth;
				
				zoomToolBar.x = stage.stageWidth - themePanel.w - zoomToolBar.width - 20;
			}
			else
			{
				shapePanel.x = stage.stageWidth;
				themePanel.x = stage.stageWidth;
				zoomToolBar.x = stage.stageWidth - zoomToolBar.width - 20;
			}
			
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
				kvsCore.bound = new Rectangle(gutter, gutter, stage.stageWidth - gutter * 2, stage.stageHeight - gutter * 2);
			}
			else
			{
				gutter = 30;
				var w:Number =  stage.stageWidth - gutter * 2 - pagePanel.w;
				if (shapePanel.isOpen)
					w -= shapePanel.w;
				else if (themePanel.isOpen)
					w -= themePanel.w;
				
				kvsCore.bound = new Rectangle(pagePanel.w + gutter, toolBar.h + gutter, w, 
					stage.stageHeight - toolBar.h - gutter * 2);
			}
		}
		
		/**
		 * 核心core初始化完毕
		 */		
		protected function kvsReadyHandler(evt:KVSEvent):void
		{
			kvsCore.changeTheme('White', false);
			pagePanel.initPageManager();
		}
		
		/**
		 * web版与桌面版的接口不同
		 */		
		protected var api:KanvasAPI;
		
		/**
		 * 装载工具条，面板的容器
		 */		
		private var uiContainer:Sprite = new Sprite;
		
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
		 * 工具条
		 */		
		public var toolBar:ToolBar = new ToolBar;
		
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
		private var mainNavControl:NavControl;
		
		/**
		 * 工具提示控制器
		 */		
		private var toolTipsManager:ToolTipsManager;
		
		
		
		
		
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