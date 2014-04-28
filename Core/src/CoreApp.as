package 
{
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.XMLConfigKit.IApp;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import commands.Command;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import model.ConfigInitor;
	import model.CoreFacade;
	import model.ElementProxy;
	
	import util.LayoutUtil;
	import util.layout.ElementLayoutInfo;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoEvent;
	import util.undoRedo.UndoRedoMannager;
	
	import view.editor.text.TextEditor;
	import view.element.ElementBase;
	import view.element.imgElement.ImgElement;
	import view.elementSelector.ElementHover;
	import view.ui.BgColorFlasher;
	import view.ui.Bubble;
	import view.ui.MainUIBase;
	import view.ui.ThumbManager;

	
	[Event(name="ready", type="KVSEvent")]
	
	/**
	 * 核心主程序, 负责核心core初始化；
	 * 
	 * 对外api和扩展api（方便对core扩展，支持不同的图形组件）都在这里；
	 * 
	 * 交互控制主要由MainUIMediator负责
	 */
	public class CoreApp extends MainUIBase implements IApp
	{
		
		
		
		//-------------------------------------------------
		//
		//
		// API
		//
		//
		//------------------------------------------------ 
		
		/**
		 * 整体窗口缩放时调用
		 */		
		public function resize():void
		{
			if (facade)
			{
				facade.sendNotification(Command.RENDER_BG_COLOR);
				drawBgInteractorShape();
				updatePastPoint();
			}
			
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 */		
		public function autoZoom():void
		{
			facade.sendNotification(Command.AUTO_ZOOM);
		}
		
		/**
		 * 创建图形：矩形， 原型，三角形, 线条，箭头等几何图形
		 * 
		 * @param type 图形类型
		 * 
		 * @param rect 图形位置尺寸信息， 这里的尺寸是指图形的原始尺寸；
		 * 
		 * 位置尺寸是相对于整个stage的；
		 */			
		public function createShape(proxy:ElementProxy):void
		{
			resetLib();
			
			facade.sendNotification(Command.CREATE_SHAPE, proxy);
		}
		
		/**
		 * 创建一个页面
		 */		
		public function createPage(proxy:ElementProxy):void
		{
			facade.sendNotification(Command.CREATE_PAGE, proxy);
		}
		
		/**
		 * 插入图片
		 */		
		public function insertIMG():void
		{
			facade.sendNotification(Command.INSERT_IMAGE);
		}
		
		
		/**
		 * 拖动当前原件，拖动创建时用到；
		 */		
		public function startDragElement():void
		{
			facade.coreMediator.startDragElement();
		}
		
		/**
		 * 停止拖动当前元件
		 */		
		public function endDragElement():void
		{
			facade.coreMediator.endDragElment();
		}
		
		/**
		 * 显示选择器
		 */		
		public function showSelector():void
		{
			facade.coreMediator.openSelector();
		}
		
		/**
		 * 隐藏选择器
		 */		
		public function hideSelector():void
		{
			facade.coreMediator.showSelector();
		}
		
		/**
		 * 获取当前元件
		 */		
		public function get currentElement():ElementBase
		{
			return facade.coreMediator.currentElement;
		}
		
		/**
		 * 撤销指令
		 */		
		public function undo():void
		{
			facade.coreMediator.undo();
		}
		
		/**
		 * 重做指令
		 */	
		public function redo():void
		{
			facade.coreMediator.redo();
		}
		
		/**
		 */		
		private function enableFallback(evt:UndoRedoEvent):void
		{
			this.dispatchEvent(evt);
		}
		
		/**
		 */		
		private function disableFallback(evt:UndoRedoEvent):void
		{
			this.dispatchEvent(evt);
		}
		
		/**
		 */		
		public function copy():void
		{
			facade.coreMediator.copy();
		}
		
		/**
		 */		
		public function cut():void
		{
			facade.coreMediator.cut();
		}
		  
		/**
		 */		
		public function paste():void
		{
			facade.coreMediator.paste();
		}
		
		/**
		 */		
		public function exportData():XML
		{
			return facade.coreProxy.exportData();
		}
		
		/**
		 */		
		public function importData(xml:XML):void
		{
			facade.coreProxy.importData(xml);
			if (stage && stage.stageWidth && stage.stageHeight)
			{
				autoZoom();
			}
			else
			{
				stage.addEventListener(Event.RESIZE, stageInitResizeHandler);
			}
		}
		
		/**
		 */		
		private function stageInitResizeHandler(e:Event):void
		{
			if (stage.stageWidth && stage.stageHeight)
			{
				stage.removeEventListener(Event.RESIZE, stageInitResizeHandler);
				autoZoom();
			}
		}
			
		/**
		 */		
		public function exportZipData():ByteArray
		{
			resetLib();
			
			return facade.coreProxy.exportZipData();
		}
		
		
		
		/**
		 * 所有图片资源的URL列表
		 */		
		public function getImgURLList():String
		{
			var temp:Array = [];
			var imgs:Vector.<ImgElement> = facade.coreProxy.imageElements;
			for each (var imgElement:ImgElement in imgs)
			{
				temp.push(imgElement.imgVO.url);
			}
			
			if (RexUtil.ifHasText(CoreFacade.coreProxy.bgVO.imgURL))
				temp.push(CoreFacade.coreProxy.bgVO.imgURL);
			
			return temp.join(",");
		}
		
		/**
		 */		
		public function getOwnPropertyElementIDList():String
		{
			var temp:Array = [];
			for each (var element:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (element.vo.property && element.vo.property.toLocaleLowerCase() == "true")
					temp.push(element.vo.id);
			}
			
			return temp.join(",");
		}
		
		
		
		
		
		
		//-------------------------------------------------------
		//
		//
		//
		//  样式控制及更新消息
		//
		//
		//
		//--------------------------------------------------------
		
		
		/**
		 * 背景颜色集合更新后通知外围程序
		 */		
		public function bgColorsUpdated(colors:XML):void
		{
			var evt:KVSEvent = new KVSEvent(KVSEvent.UPDATE_BG_COLOR_LIST);
			evt.colorList = colors;
			this.dispatchEvent(evt);			
		}
		
		/**
		 * 改变背景色
		 */		
		public function changeBgColor(index:uint):void
		{
			facade.sendNotification(Command.CHANGE_BG_COLOR, index);
		}
		
		/**
		 */		
		public function previewBgColor(index:uint):void
		{
			facade.sendNotification(Command.PREVIEW_BG_COLOR, index);
		}
		
		/**
		 * 背景颜色更新后通知外围程序
		 */		
		public function bgColorUpdated(colorIndex:uint):void
		{
			var evt:KVSEvent = new KVSEvent(KVSEvent.UPDATE_BG_COLOR);
			evt.colorIndex = colorIndex;
			this.dispatchEvent(evt);
		}
		
		/**
		 * 背景图加载完毕或者删除成功后通知外围程序
		 */		
		public function bgImgUpdated(imgData:BitmapData):void
		{
			var evt:KVSEvent = new KVSEvent(KVSEvent.UPDATE_BG_IMG);
			evt.bgIMG = imgData;
			
			this.dispatchEvent(evt);
		}
		
		/**
		 * 删除背景图
		 */		
		public function deleteBgImg():void
		{
			facade.sendNotification(Command.DELETE_BG_IMG);
		}
		
		/**
		 * 插入背景图
		 */		
		public function insertBgImg(handler:Function = null):void
		{
			facade.sendNotification(Command.CHANGE_BG_IMG, handler);
		}
		
		/**
		 * 改变整体风格样式
		 */		
		public function changeTheme(value:String, redoable:Boolean = true):void
		{
			facade.sendNotification(Command.CHANGE_THEME, {theme:value,redoable:redoable});
		}
		
		/**
		 * 整体风格样式改变后通知外围程序
		 */		
		public function themeUpdated(value:String):void
		{
			var evt:KVSEvent = new KVSEvent(KVSEvent.THEME_UPDATED);
			evt.themeID = value;
			
			this.dispatchEvent(evt);
		}
		
		
		
									
		
			
			
			
			
		
		//-------------------------------------------------------
		//
		//
		//
		//  全屏状态控制
		//
		//
		//
		//--------------------------------------------------------
		
		
		/**
		 */		
		public function toPreview():void
		{
			curScreenState.toFullScreenState();
			CoreFacade.coreMediator.toPrevMode();
		}
		
		/**
		 */		
		public function returnFromPrev():void
		{
			curScreenState.toNormalState();
			CoreFacade.coreMediator.toUnSelectedMode();
		}
		
		
		
		
		
		
		
		
		
		//-----------------------------------------
		//
		//
		//  初始化
		//
		//
		//-----------------------------------------
		
		/**
		 */		
		public function CoreApp()
		{
			super();
			
			//Security.allowDomain("*");
		}
		
		/**
		 * 启动Core的初始化：UI， MVC, 配置初始化
		 */
		public function startInit():void
		{
			resetLib();
			
			initUI();
			initMVC();
			
			new ConfigInitor(this);
			
			// 加载嵌入子体
			//FlowTextManager.loadFont("./FontLib.swf");
		}
		
		/**
		 */		
		public function resetLib():void
		{
			XMLVOLib.currentLib = xmlLib;
		}
	
		/**
		 */		
		private var xmlLib:XMLVOLib = new XMLVOLib;
		
		/**
		 * UI 构成初始化
		 */		
		private function initUI():void
		{
			// 值越高，动画播放更流畅, 但更消耗性能 
			stage.frameRate = 30;
			
			thumbManager = new ThumbManager(this);
			bgColorFlasher = new BgColorFlasher(this);

			Bubble.init(stage);

			
			//画布与舞台布局信息转换器
			layoutTransformer = new LayoutTransformer(canvas);
			
			// 形变控制的的位置信息计算器与鼠标感应器的要分开
			elementLayoutGetter = new ElementLayoutInfo(layoutTransformer);
			hoverEffect = new ElementHover(elementLayoutGetter, canvas);
			
			// 解决IE初始化时有一段时间宽高为0的问题
			if (stage.stageWidth == 0 || stage.stageHeight == 0)
				addEventListener(Event.ENTER_FRAME, updateCanvasPositionEnterFrame);
			else
				updateCanvasPosition();
			
			//自动对齐划线的UI
			addChild(autoAlignUI);
			
			addChild(dragSlectUI);
			
			// 文本编辑器
			textEditor = TextEditor.instance;
			textEditor.layoutTransformer = this.layoutTransformer;
			addChild(textEditor);
			
			drawBgInteractorShape();
			updatePastPoint();
		}
		
		/**
		 * 
		 */		
		public var thumbManager:ThumbManager;
		
		/**
		 */		
		public var bgColorFlasher:BgColorFlasher;
		
		/**
		 */		
		private function initMVC():void
		{
			facade = CoreFacade.instance;
			facade.startApp(this);
		}
		
		/**
		 */		
		private function updateCanvasPositionEnterFrame(e:Event):void
		{
			if (stage.stageWidth != 0 && stage.stageHeight != 0)
			{
				updateCanvasPosition();
				removeEventListener(Event.ENTER_FRAME, updateCanvasPositionEnterFrame);
			}
		}
		
		// 主场景, 默认居中对齐
		private function updateCanvasPosition():void
		{
			canvas.x = .5 * stage.stageWidth;
			canvas.y = .5 * stage.stageHeight;
			
			synBgImageToCanvas();
		}
		
		/**
		 * 初始化完毕
		 */	
		public function ready():void
		{
			// 撤销开启关闭消息监听与发送, UI根据此消息决定撤销按钮可否被点击;
			UndoRedoMannager.onEnable(enableFallback);
			UndoRedoMannager.onDisable(disableFallback);
			UndoRedoMannager.ifReady = true;
			
			this.dispatchEvent(new KVSEvent(KVSEvent.READY));
		}

		/**
		 * 只要画布位置/比例/尺寸变更时，都需要更新复制粘贴点
		 */		
		public function updatePastPoint():void
		{
			PAST_LOC = LayoutUtil.stagePointToElementPoint(stage.stageWidth * .5, stage.stageHeight * .5, canvas);
		}
		
		/**
		 * 复制粘贴时，元素的位置默认为画布中心点，然后依次叠加
		 * 
		 * 当画布位置改变或者缩放后，刷新；
		 */		
		public static var PAST_LOC:Point = new Point();
			
		
		
		
		
		//-------------------------------------------------
		//
		//
		//  UI 组件
		//
		//
		//-------------------------------------------------
		
		/**
		 * 鼠标滑过元件时的效果渲染器
		 */		
		public var hoverEffect:ElementHover;
		
		/**
		 * 元件的布局信息获取器, 用来绘制型变框与鼠标感应框 
		 */		
		private var elementLayoutGetter:ElementLayoutInfo;
		
		/**
		 * 画布与stage坐标转换器
		 */		
		public var layoutTransformer:LayoutTransformer;
		
		/**
		 * 文本编辑器 
		 */		
		public var textEditor:TextEditor;
		
		/**
		 * 包裹核心core的UI, 于此UI碰撞的元件无法接收到鼠标交互
		 */		
		public var externalUI:DisplayObject;
		
		/**
		 *绘制选框的容器，同时用来检测他碰到了谁 
		 */		
		public var dragSlectUI:Shape = new Shape;
		
		/**
		 *绘制自动对齐的虚线UI
		 */	
		public var autoAlignUI:Shape = new Shape;
		
		
		
		
		
		
		//-------------------------------------------------------
		//
		//
		// 背景
		//
		//
		//--------------------------------------------------------
		
		
		/**
		 * 绘制背景填充色
		 */
		public function renderBGWithColor(color:uint = 0xffffff):void
		{
			bgColorFlasher.render(color);
		}
		
		/**
		 * 绘制背景
		 */		
		public function drawBgInteractorShape():void
		{
			canvas.drawBG(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
		}
		
		
		
		
		
		
		//--------------------------------
		//
		//
		//  构成元件
		//
		//
		//---------------------------------
		
		
		/**
		 * 控制器
		 */	
		public function get facade():CoreFacade
		{
			return __facade;
		}
		
		public function set facade(value:CoreFacade):void
		{
			__facade = value;
		}
		
		private var __facade:CoreFacade;
		
		/**
		 * 是否为AIR桌面程序，此属性在客户端中设置为true。
		 */
		public static var isAIR:Boolean;
	}
}