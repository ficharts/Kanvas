package com.kvs.charts.chart2D.encry
{
	import com.kvs.charts.chart2D.core.Chart2DStyleTemplate;
	import com.kvs.charts.chart2D.core.events.FiChartsEvent;
	import com.kvs.charts.common.IChart;
	import com.kvs.charts.common.Menu;
	import com.kvs.utils.ExternalUtil;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.App;
	import com.kvs.utils.XMLConfigKit.IApp;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.csv.CSVLoader;
	import com.kvs.utils.csv.CSVParseEvent;
	import com.kvs.utils.graphic.ImgSaver;
	import com.kvs.utils.layout.LayoutManager;
	import com.kvs.utils.net.URLService;
	import com.kvs.utils.net.URLServiceEvent;
	import com.kvs.utils.system.OS;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	
	/**
	 */
	[Event(name="legendDataChanged", type = "com.kvs.charts.chart2D.core.events.FiChartsEvent")]
	[Event(name="ready", type = "com.kvs.charts.chart2D.core.events.FiChartsEvent")]
	[Event(name="itemClicked", type = "com.kvs.charts.chart2D.core.events.FiChartsEvent")]
	[Event(name="rendered", type = "com.kvs.charts.chart2D.core.events.FiChartsEvent")]

	
	/**
	 * 这是所有图表的主程序基类，负责初始化过程，包含对外接口�
	 */	
	public class CSB extends App
	{
		/**
		 * 版本�
		 */	
		public static const VARSION:String = "1.3.2";
		
		/**
		 */		
		public static const MIN_SIZE:uint = 150;
		
		/**
		 */		
		public function CSB()
		{
			super();
			
			StageUtil.initApplication(this, preInit);
		}
		
		
		
		
		
		//------------------------------------------------
		//
		// 
		//
		//
		//
		//------------------------------------------------
		
		/**
		 */		
		private function preInit():void
		{
			resetLib();
			dec.run(this);
		}
		
		/**
		 */		
		protected var dec:Dec;
		
		
		/**
		 * 注入图表的基础配置文件�此配置文件包含默认的样式模板, 菜单语言配置等；
		 * 
		 * 图表初始化时先初始此文件�
		 * 
		 */		
		internal function initStyleTempalte(value:String):void
		{
			var defaultConfig:XML = XML(value);
			
			for each (var item:XML in defaultConfig.styles.children())
				Chart2DStyleTemplate.pushTheme(XML(item.toXMLString()));
			
			//注册全局样式模板
			for each (item in defaultConfig.child('template').children())
				XMLVOLib.registWholeXML(item.@id, item, item.name().toString());
			
			XMLVOMapper.fuck(defaultConfig.menu, menu);
		}
		
		
		
		
		
		
		
		
		//-----------------------------------------------------------------------------
		//
		// 公共接口, 这些接口可以用在AS项目或者AIR移动项目�
		//
		// 这里用了预处理，即便图表没有初始化完毕也可定义其属性和配置�初始化完毕后自动生效
		//
		//-----------------------------------------------------------------------------
		
		
		/**
		 * 在被添加到显示列表之前就要设置用户配置文件， 
		 * 
		 * 只要一被添加进显示列表则开始初始化 Chart�将用户配置文件作为参数传入；
		 */		
		public function setUserConfig(value:XML):void
		{
			embedCustomConfig = value;
		}
		
		/**
		 */		
		protected var embedCustomConfig:XML;
		
		/**
		 */		
		protected var customConfig:XML;
		
		
		/**
		 */		
		private var _ifDataScalable:Boolean = false;

		/**
		 * 是否开启数据缩放，开启后<code>scaleData</code>方法才会生效
		 */
		public function get ifDataScalable():Boolean
		{
			return _ifDataScalable;
		}

		/**
		 * @private
		 */
		public function set ifDataScalable(value:Boolean):void
		{
			_ifDataScalable = value;
			
			if (ifReady)
				chart.setDataScalable(_ifDataScalable);
			else
				ifDataScalableChanged = true;
		}
		
		/**
		 */		
		private var ifDataScalableChanged:Boolean = false;
		
		/**
		 * 
		 * 根据数据范围缩放图表
		 * 
		 * @param valueFrom 数据范围的起点�
		 * @param valueTo   数据范围的终点�
		 * 
		 */		
		public function scaleData(valueFrom:Object, valueTo:Object):void
		{
			if (ifReady)
			{
				chart.scaleData(valueFrom, valueTo);
			}
			else
			{
				dataScaleForm = valueFrom;
				dataScaleTo = valueTo;
				ifScaleDataChanged = true;
			}
		}
		
		/**
		 */		
		private var ifScaleDataChanged:Boolean = false;
		
		/**
		 */		
		private var dataScaleForm:Object;
		
		/**
		 */		
		private var dataScaleTo:Object;
		
		
		
		/**
		 * 设置配置文件
		 *  
		 * @param value  XML格式的字符串
		 * 
		 */		
		public function setConfigXML(value:String):void
		{	
			if (ifReady)
			{
				setConfigXMLHandler(value);
			}
			else
			{
				this._configXML = value;
				this.ifConfigChanged = true;
			}
		}
		
		/**
		 * 设置配置文件的路径或者服务器地址;
		 */		
		public function setConfigFileURL(value:String):void
		{
			if (ifReady)
			{
				requestConfigURL(value);
			}
			else
			{
				this._configFileURL = value;
				this.ifConfigFileURLChanged = true;
			}
		}
		
		
		/**
		 * 设置图表数据，图表数据与配置可分离， 可借此实现动态更新图表数据；
		 *  
		 * @param value XML格式的字符串
		 * 
		 */		
		public function setDataXML(value:String):void
		{
			if (ifReady)
			{
				getXMLDataHandler(value);
			}
			else
			{
				this._dataXML = value;
				this.ifDataChanged = true;
			}
		}
		
		/**
		 */		
		public function setDataFileURL(value:String):void
		{
			requestDataURL(value);
		}
		
		/**
		 * 设置图表样式   white 或� black 默认�white
		 */		
		public function setStyle(value:String):void
		{
			if (ifReady)
			{
				setStyleHandler(value);
			}
			else
			{
				this._style = value;
				this.ifStyleChanged = true;
			}
		}
		
		/**
		 * 渲染图表�图表在改变了尺寸�配置文件�数据后都需重新渲染�
		 */		
		public function render():void
		{
			if (ifReady)
			{
				this.renderHandler();
			}
			else
			{
				ifPreRender = true;
			}
		}
		
		/**
		 */		
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 */		
		private var _width:Number = CSB.MIN_SIZE;
		
		/**
		 */		
		override public function set width(value:Number):void
		{
			if (ifReady)
				chart.chartWidth = _width = value;
			else
				_width = value;
		}
		
		/**
		 */		
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 */		
		override public function set height(value:Number):void
		{
			if (ifReady)
				chart.chartHeight = _height = value;
			else
				_height = value;
		}
		
		/**
		 */		
		private var _height:Number = CSB.MIN_SIZE;
		
		/**
		 * 存储图表截图
		 */		
		public function saveImg(name:String = "ficharts.png"):void
		{
			if (ifReady)
				ImgSaver.saveImg(this, name);
		}
		
		
		
		
		
		
		//----------------------------------------
		//
		// 配置接口
		//
		//----------------------------------------
		
		private function requestConfigURL(url:String, args:String = null):void
		{
			updateInfoLabel(loadingDataInfo);
			
			var urlService:URLService = new URLService();
			urlService.addEventListener(URLServiceEvent.GET_DATA, getConfigServiceHandler, false, 0, true);
			urlService.addEventListener(URLServiceEvent.LOADING_ERROR, loadingDataErrorHandler, false, 0, true);
			urlService.requestService(url, args);
		}
		
		/**
		 */		
		private function getConfigServiceHandler(evt:URLServiceEvent):void
		{
			ExternalUtil.call("FiCharts.configFileLoaded", id, evt.data);
			
			setConfigXMLHandler(evt.data);
			renderHandler();
		}
		
		/**
		 */
		private function setConfigXMLHandler(value:String):void
		{
			if (value)
			{
				this.resetLib();				
				chart.configXML = XML(value);
			}
		}
		
		/**
		 */		
		private function setStyleHandler(value:String):void
		{
			this.resetLib();
			chart.setStyle(value);
		}
		
		/**
		 */		
		private function setCustomStyleHandler(value:String):void
		{
			this.resetLib();
			chart.setCustomStyle(XML(value));
		}
		
		
		
		
		//----------------------------------------
		//
		// 数据接口
		//
		//----------------------------------------
		
		/**
		 */
		private function requestDataURL(url:String, args:String = null):void
		{
			updateInfoLabel(loadingDataInfo);
			
			var urlService:URLService = new URLService();
			urlService.addEventListener(URLServiceEvent.GET_DATA, getDataServiceHandler, false, 0, true);
			urlService.addEventListener(URLServiceEvent.LOADING_ERROR, loadingDataErrorHandler, false, 0, true);
			urlService.requestService(url, args);
		}
		
		/**
		 * @param evt
		 */
		private function getDataServiceHandler(evt:URLServiceEvent):void
		{
			ExternalUtil.call("FiCharts.dataFileLoaded", id, evt.data);
			
			getXMLDataHandler(evt.data);
			renderHandler();
		}
		
		/**
		 * 获取到了数据文件
		 */
		private function getXMLDataHandler(value:String):void
		{
			if (value)
				chart.dataXML = XML(value);
		}
		
		/**
		 */		
		private function requestCSVData(value:String, columns:Array):void
		{
			updateInfoLabel(loadingDataInfo);
			
			csvLoader = new CSVLoader;
			csvLoader.addEventListener(CSVParseEvent.PARSE_COMPLETE, csvDataLoaded, false, 0, true);
			csvLoader.columnNames = columns;
			csvLoader.loadCVS(value);
		}
		
		/**
		 */		
		private function csvDataLoaded(evt:CSVParseEvent):void
		{
			chart.dataVOes = evt.parsedVOes;
			renderHandler();
			ExternalUtil.call("FiCharts.csvFileLoaded", id);
			
		}
		
		/**
		 * 设置数据，数据格式
		 */		
		public function setDataArry(arr:Array):void
		{
			var dataVOes:Vector.<Object> = new Vector.<Object>;
			
			for each (var item:Object in arr)
				dataVOes.push(item);
				
			setDataVOes(dataVOes);
		}
		
		/**
		 * 设置数据，对象数组格式
		 */		
		public function setDataVOes(vos:Vector.<Object>):void
		{
			if (ifReady)
			{
				chart.dataVOes = vos;
			}
			else
			{
				dataVOes = vos;
				ifDataVOesChanged = true;
			}
		}
		
		/**
		 */		
		private var dataVOes:Vector.<Object>;
		
		/**
		 */		
		private var ifDataVOesChanged:Boolean = false;
		
		/**
		 */		
		private var csvLoader:CSVLoader 
		
		/**
		 */		
		private function loadingDataErrorHandler(evt:URLServiceEvent):void
		{
			updateInfoLabel(loadingDataErrorInfo + ": " + evt.data);
		}
		
		
		
		//-------------------------------------------
		//
		// 
		//  渲染及交互事�
		//
		//
		//-------------------------------------------
		
		/**
		 */		
		private function itemClickHandler(evt:FiChartsEvent):void
		{
			//evt.stopPropagation();
			ExternalUtil.call('FiCharts.itemClick', id, evt.dataItem.metaData);
		}
		
		/**
		 */		
		private function itemOverHandler(evt:FiChartsEvent):void
		{
			//evt.stopPropagation();
			ExternalUtil.call('FiCharts.itemOver', id, evt.dataItem.metaData);
		}
		
		/**
		 */		
		private function itemOutHandler(evt:FiChartsEvent):void
		{
			//evt.stopPropagation();
			ExternalUtil.call('FiCharts.itemOut', id, evt.dataItem.metaData);
		}
		
		/**
		 */		
		protected function renderedHandler(evt:FiChartsEvent):void
		{
			//evt.stopPropagation();
			ExternalUtil.call('FiCharts.rendered', id);
		}
		
		/**
		 */		
		protected function renderHandler():void
		{
			this.infoLabel.visible = false;
			chart.render();
		}
		
		/**
		 * 坐标轴标签点击事件
		 */		
		private function axisLabelClicked(evt:FiChartsEvent):void
		{
			//evt.stopPropagation();
			ExternalUtil.call('FiCharts.labelClicked', id, evt.label, evt.labelIndex);
		}
		
		
		//---------------------------------------------------------
		//
		// 初始�
		//
		//---------------------------------------------------------
		
		/**
		 * 
		 */
		internal function init():void
		{
			if (OS.isWebSystem)
				Security.allowDomain("*");
			
			if (OS.isWebSystem)
			{
				initMenu();
				initInterfaces();
			}
			
			// 存在外部配置文件的话�先加载外部配置文件， 加载成功�
			// 应用配置文件�如果存在嵌入配置文件�则外部配置文件需要继�
			// 嵌入的配置文件；嵌入配置文件优先级最高；
			if (RexUtil.ifTextNull(customStyleFileURL) == false)
				loadCustomStyle(customStyleFileURL);
			else
				lauchApp();
		}
		
		
		
		// ----------------------------------------
		//
		// 加载外部配置文件
		//
		//-----------------------------------------
		private function loadCustomStyle(url:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, loadCustomStyleFileComplete, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
			urlLoader.load(new URLRequest(url));
		}
		
		/**
		 */		
		private function loadCustomStyleFileComplete(evt:Event):void
		{
			var externalConfigByte:ByteArray = (evt.target as URLLoader).data;
			externalConfigByte.uncompress();
			
			var externalCustomConfig:XML = XML(externalConfigByte.toString());
			
			// 
			// 预先配置文件有两种： 嵌入式和外部加载方式，且嵌入优先于外部加载方式；
			// 两者同时存在时�外部加载的要继承预先嵌入的， 作为自定义样式附给图�
			//
			if (this.embedCustomConfig)
				this.customConfig = XMLVOMapper.extendFrom(embedCustomConfig, externalCustomConfig);
			else
				customConfig = externalCustomConfig;
			
			this.lauchApp();
		}
		
		/**
		 */		
		private function errorHandler(evt:Event):void
		{
			this.lauchApp();
		}
		
		
		//-----------------------------------------------
		//
		// 语言与邮件菜�
		//
		//-----------------------------------------------
		
		/**
		 */		
		private var menu:Menu = new Menu;
		
		/**
		 * 右键菜单�
		 */		
		private function initMenu():void
		{
			// 移动设备下不支持 右键菜单
			if (ContextMenu.isSupported)
			{
				var myContextMenu:ContextMenu = new ContextMenu();
				myContextMenu.hideBuiltInItems();
				var item:ContextMenuItem;
				
				item = new ContextMenuItem(menu.saveAsImage);
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, saveImageHandler);
				myContextMenu.customItems.push(item);
				
				item = new ContextMenuItem("新浪微博");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(evt:Event):void{
					flash.net.navigateToURL(new URLRequest('http://weibo.com/u/2431448684'), '_blank');
				});
				
				myContextMenu.customItems.push(item);
				
				item = new ContextMenuItem("QQ群:184587429");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(evt:Event):void{
					flash.net.navigateToURL(new URLRequest('http://qun.qzone.qq.com/group#!/184587429/home'), '_blank');
				});
				myContextMenu.customItems.push(item);
				
				item = new ContextMenuItem(menu.about + " FiCharts");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				myContextMenu.customItems.push(item);
				
				item = new ContextMenuItem(menu.version + VARSION);
				item.enabled = false;
				myContextMenu.customItems.push(item);
				
				this.contextMenu = myContextMenu;
			}
		}
		
		/**
		 * 保存图片
		 */		
		public function saveImage():void
		{
			ImgSaver.saveImg(this, "ficharts.png");
		}
		
		/**
		 * 返回图表的截图，以base64编码
		 */		
		private function getChartBase64Data():String
		{
			return ImgSaver.get64Data(this);
		}
		
		/**
		 */		
		private function saveImageHandler(evt:Event):void
		{
			saveImage();
		}
		
		/**
		 */		
		private function menuItemSelectHandler(evt:ContextMenuEvent):void
		{
			flash.net.navigateToURL(new URLRequest('http://www.ficharts.com'), '_blank');
		}
		
		//----------------------------------------------------
		//
		// 外部配置及数据接口处�
		//
		//-----------------------------------------------------
		protected function initInterfaces():void
		{
			ExternalUtil.addCallback("ifDataScalable", ifChartDataScalable);
			
			ExternalUtil.addCallback("setConfigXML", setConfigXMLHandler);
			ExternalUtil.addCallback("setConfigFile", requestConfigURL);
			
			ExternalUtil.addCallback("setStyle", setStyleHandler);
			ExternalUtil.addCallback('setCustomStyle', setCustomStyleHandler);
			
			ExternalUtil.addCallback("setDataXML", getXMLDataHandler);
			ExternalUtil.addCallback("setDataFile", requestDataURL);
			
			ExternalUtil.addCallback("setCSVData", requestCSVData);
			ExternalUtil.addCallback("render", renderHandler);
			ExternalUtil.addCallback("getChartBase64Data", getChartBase64Data);
			
			ExternalUtil.addCallback("setWebMode", setWebMode);
				
			// Flash的初始化参数配置
			_configFileURL = stage.loaderInfo.parameters['configFile'];
			_style = stage.loaderInfo.parameters['style'];
			
			customStyleFileURL = stage.loaderInfo.parameters['customStyleFile'];
			
			id = stage.loaderInfo.parameters['id'];
			this.noDataInfo = stage.loaderInfo.parameters['noDataInfo'];
			this.loadingDataInfo = stage.loaderInfo.parameters['loadingDataInfo'];
			this.loadingDataErrorInfo = stage.loaderInfo.parameters['loadingDataErrorInfo'];
			
			ExternalUtil.call("FiCharts.beforeInit", id);
		}
		
		/**
		 */		
		private function ifChartDataScalable():Boolean
		{
			return chart.ifDataScalable();
		}
		
		
		
		
		//------------------------------------
		//
		// 图表构建与启�
		//
		//------------------------------------
		/**
		 * 应用图表初始化配置项�创建�启动图表�
		 */		
		private function lauchApp():void
		{
			// 桌面环境下图表默认自适应舞台，移动平台下需手动设置
			if (OS.isDesktopSystem)
				ifAutoResizeToStage = true;
			else
				ifAutoResizeToStage = false;
			
			createChart();
			stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			
			infoLabel = new LabelUI;
			infoLabel.style = new LabelStyle;
			addChild(infoLabel);
			
			// 初始化完毕后提示无数�
			updateInfoLabel(noDataInfo);
			
			resizeChart();
			
			if (OS.isWebSystem)
			{
				//
				// 如果有预先设置好的自定义配置�将其设置为自定义样式�
				//
				if (this.customConfig)
					chart.setCustomStyle(customConfig);
				
				if (RexUtil.ifTextNull(_style) == false)
					setStyleHandler(_style);
				
				//如果配置了配置文件的路径，则直接加载�
				if (RexUtil.ifTextNull(_configFileURL) == false)
					requestConfigURL(_configFileURL);
				
				ExternalUtil.call("FiCharts.ready", id);
			}
			
			// 
			// 如果图表未添加仅显示列表前调用配置渲染接�
			// 此时调用生效
			//
			//
			ifReady = true;
			
			if (this.ifConfigChanged)
			{
				this.setConfigXML(this._configXML);
				ifConfigChanged = false;
			}
			
			if (this.ifDataChanged)
			{
				this.setDataXML(this._dataXML);
				ifDataChanged = false;
			}
			
			if (this.ifDataVOesChanged)
			{
				this.setDataVOes(this.dataVOes);
				ifDataVOesChanged = false;
			}
			
			if (this.ifStyleChanged)
			{
				this.setStyle(this._style);
				ifStyleChanged = false;
			}
			
			if (this.ifPreRender)
			{
				this.render();
				ifPreRender = false;
			}
			
			if (ifDataScalableChanged)
			{
				this.chart.setDataScalable(this.ifDataScalable);
				ifDataScalableChanged = false;
			}
			
			if (this.ifScaleDataChanged && this.ifDataScalable)
			{
				this.scaleData(this.dataScaleTo, dataScaleTo);
				ifScaleDataChanged = false;
			}
			
			if (this.ifConfigFileURLChanged)
			{
				this.setConfigFileURL(this._configFileURL);
				ifConfigFileURLChanged = false;
			}
			
			// 初始化过程完�
			this.dispatchEvent(new FiChartsEvent(FiChartsEvent.READY));
		}
		
		/**
		 *  如果�true 表明初始化已完毕
		 */		
		public var ifReady:Boolean = false;
		
		/**
		 * 初始化一些全局事件�当图表被添加进显示列表以后才开始创建图表；
		 */		
		protected function createChart():void
		{
			// 子类需先创建图�
			addChild(chart as DisplayObject);
			(chart as EventDispatcher).addEventListener(FiChartsEvent.RENDERED, renderedHandler, false, 0, true);
			
			(chart as EventDispatcher).addEventListener(FiChartsEvent.ITEM_OVER, itemOverHandler, false, 0, true);
			(chart as EventDispatcher).addEventListener(FiChartsEvent.ITEM_OUT, itemOutHandler, false, 0, true);
			(chart as EventDispatcher).addEventListener(FiChartsEvent.ITEM_CLICKED, itemClickHandler, false, 0, true);
			(chart as EventDispatcher).addEventListener(FiChartsEvent.AXIS_LABEL_CLICKED, axisLabelClicked, false, 0, true);
		}
		
		
		//--------------------------------------------------
		//
		//
		// 尺寸控制
		//
		//
		//---------------------------------------------------
		
		
		/**
		 */		
		private function resizeHandler(evt:Event):void
		{
			if (ifWebMode)
			{
				if (stage.stageWidth <=  CSB.MIN_SIZE || stage.stageHeight <= CSB.MIN_SIZE)
					return;
				
				if (infoLabel.visible)
					LayoutManager.stageCenter(infoLabel, stage);
				
				resizeChart();
				chart.render();
			}
		}
		
		/**
		 */
		private function resizeChart():void
		{
			if (this.ifWebMode)
			{
				chart.chartWidth = _width = stage.stageWidth;
				chart.chartHeight = _height = stage.stageHeight;
			}
			else
			{
				chart.chartWidth = _width;
				chart.chartHeight = _height;
			}
		}
		
		/**
		 */		
		protected var chart:IChart;
		
		/**
		 */		
		private function updateInfoLabel(info:String):void
		{
			if(this.infoLabel.visible == false) infoLabel.visible = true;
				
			this.infoLabel.text = info;
			infoLabel.render();
			LayoutManager.stageCenter(infoLabel, stage);
		}
		
		/**
		 * 此接口只有在网页模式下才会被调用
		 */		
		private function setWebMode():void
		{
			this.ifWebMode = true;
		}
		
		/**
		 *  网页模式� 图表的宽高会自动适应容器尺寸
		 * 
		 *  Flash项目中，图表的宽高随用户设置
		 */		
		public var ifWebMode:Boolean = false;
		
		/**
		 * 信息提示标签;
		 */		
		private var infoLabel:LabelUI;
		
		/**
		 */		
		private var noDataInfo:String;
		
		/**
		 */		
		private var loadingDataErrorInfo:String;
		
		/**
		 */		
		private var loadingDataInfo:String;
		
		/**
		 */		
		private var id:String;
		
		
		/**
		 * 默认图表会自动适应舞台尺寸，无需设置宽高，可自适应网页中的容器尺寸�
		 * 
		 * Flash/AIR项目中根据需要关闭此特性，手动设置图表尺寸�
		 */		
		public var ifAutoResizeToStage:Boolean = true;
		
		/**
		 */		
		private var _configFileURL:String;
		private var _configXML:String;
		private var _dataXML:String;
		
		private var _style:String;
		private var customStyleFileURL:String;
		
		/**
		 */		
		private var ifConfigChanged:Boolean = false;
		private var ifStyleChanged:Boolean = false;
		private var ifDataChanged:Boolean = false;
		private var ifConfigFileURLChanged:Boolean = false;
		private var ifPreRender:Boolean = false;
		
		
	}
}