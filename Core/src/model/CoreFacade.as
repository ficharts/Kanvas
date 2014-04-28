package model
{
	import commands.*;
	
	import model.vo.ArrowVO;
	import model.vo.DialogVO;
	import model.vo.ElementVO;
	import model.vo.GroupVO;
	import model.vo.ImgVO;
	import model.vo.LineVO;
	import model.vo.PageVO;
	import model.vo.ShapeVO;
	import model.vo.StarVO;
	import model.vo.TextVO;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	import util.ElementCreator;
	
	import view.MediatorNames;
	import view.element.*;
	import view.element.imgElement.ImgElement;
	import view.element.shapes.*;
	import view.element.text.TextEditField;
	import view.interact.CoreMediator;
	import view.ui.Canvas;
	
	/**
	 * 核心MVC控制器
	 */
	public class CoreFacade extends Facade
	{
		public static function clear():void
		{
			var canvas:Canvas = instance._coreMediator.canvas;
			while (canvas.numChildren > 1) canvas.removeChildAt(1);
			instance._coreProxy.elements.length = 0;
			instance._coreMediator.pageManager.removeAllPages();
		}
		/**
		 */		
		public static function addElement(element:ElementBase):void
		{
			instance._coreMediator.addElement(element);
			instance._coreProxy.addElement(element);
		}
		
		/**
		 */		
		public static function addElementAt(element:ElementBase, index:int):void
		{
			instance._coreMediator.addElementAt(element, index);
			instance._coreProxy.addElement(element);
		}
		
		/**
		 */		
		public static function removeElement(element:ElementBase):void
		{
			instance._coreMediator.removeElementFromView(element);
			instance._coreProxy.removeElement(element);
		}
		
		public static function getElementIndex(element:ElementBase):int
		{
			return instance._coreMediator.getElementIndex(element);
		}
		
		/**
		 */		
		public static function sendNotification(msg:String, body:Object = null, type:String = ''):void
		{
			instance.sendNotification(msg, body, type);
		}
		
		/**
		 * 获取主UI的控制器
		 */		
		public static function get coreMediator():CoreMediator
		{
			return instance._coreMediator;
		}
		
		public function get coreMediator():CoreMediator
		{
			return _coreMediator;
		}
		
		/**
		 */		
		private var _coreMediator:CoreMediator;
		
		/**
		 */		
		public static function get coreProxy():CoreProxy
		{
			return instance._coreProxy;
		}
		
		public function get coreProxy():CoreProxy
		{
			return _coreProxy;
		}
		
		/**
		 */		
		private var _coreProxy:CoreProxy;
		
		/**
		 * 单例
		 */
		private static var _instance:CoreFacade;
		
		/**
		 */		
		public function CoreFacade(key:Key)
		{
			super();
			
			initElements();
			initCommands();
		}
		
		/**
		 */		
		private function initElements():void
		{
			ElementCreator.registerElement('circle', Circle, ShapeVO);
			ElementCreator.registerElement('rect', Rect, ShapeVO);
			ElementCreator.registerElement('arrow', Arrow, ArrowVO);
			ElementCreator.registerElement('doubleArrow', DoubleArrow, ArrowVO);
			ElementCreator.registerElement('triangle', Triangle, ShapeVO);
			ElementCreator.registerElement('stepTriangle', StepTriangle, ShapeVO);
			ElementCreator.registerElement('diamond', Diamond, ShapeVO);
			ElementCreator.registerElement('star', Star, StarVO);
			ElementCreator.registerElement('line', LineElement, LineVO);
			ElementCreator.registerElement('arrowLine', ArrowLine, LineVO);
			ElementCreator.registerElement('doubleArrowLine', DoubleArrowLine, LineVO);
			ElementCreator.registerElement('text', TextEditField, TextVO);
			
			ElementCreator.registerElement('img', ImgElement, ImgVO);
			ElementCreator.registerElement('hotspot', HotspotElement, ElementVO);
			ElementCreator.registerElement('camera', Camera, ElementVO);
			ElementCreator.registerElement('group', GroupElement, GroupVO);
			ElementCreator.registerElement('dashRect', DashRect, ShapeVO);
			ElementCreator.registerElement('dialog', DialogUI, DialogVO);
			ElementCreator.registerElement("page", PageElement, PageVO);
		}
		
		/**
		 * 获取单例
		 */
		public static function get instance():CoreFacade
		{
			if (_instance == null)
				_instance = new CoreFacade(new Key);
			
			return _instance as CoreFacade;
		}
		
		/**
		 * 启动APP
		 */
		public function startApp(main:CoreApp):void
		{
			_coreProxy = new CoreProxy(ProxyNames.CORE_PROXY, main.canvas)
			registerProxy(_coreProxy);
			
			_coreMediator = new CoreMediator(MediatorNames.CORE_MEDIATOR, main);
			registerMediator(_coreMediator);
		}
		
		/**
		 * 初始化命令
		 */
		private function initCommands():void
		{
			// 创建与删除
			registerCommand(Command.CREATE_SHAPE, CreateShapeCMD);
			
			registerCommand(Command.INSERT_IMAGE, inserImgCommad);
			
			registerCommand(Command.PRE_CREATE_TEXT, PreCreateTextCMD);
			registerCommand(Command.CREATE_TEXT, CreateTextCMD);
			
			registerCommand(Command.CREATE_PAGE, CreatePageCMD);
			
			registerCommand(Command.DELETE_ElEMENT, DeleteElementCMD);
			registerCommand(Command.DELETE_IMG, delImgCommad);
			registerCommand(Command.DELETE_TEXT, DeleteTextCMD);
			registerCommand(Command.DELETE_PAGE, DeletePageCMD);
			registerCommand(Command.DELETE_CHILD_IN_TEM_GROUP, DeleteChildInTemGroupCMD);
			registerCommand(Command.DELETE_BG_IMG, DelBgImgCMD);
			
			registerCommand(Command.TEM_TO_GROUP, GroupCMD);
			registerCommand(Command.GROUP_TO_TEM, UnGroupCMD);
			
			// 编辑控制
			registerCommand(Command.AUTO_ZOOM, AutoZoomCMD);
			registerCommand(Command.UN_DO, UnDoCMD);
			registerCommand(Command.RE_DO, ReDoCMD);
			
			registerCommand(Command.SElECT_ELEMENT, SelectElementCMD);
			registerCommand(Command.UN_SELECT_ELEMENT, UnSelectElementCMD);
			
			registerCommand(Command.CHANGE_THEME, SetThemeCMD);
			
			registerCommand(Command.PREVIEW_BG_COLOR, PreviewBgColorCMD);
			registerCommand(Command.CHANGE_BG_COLOR, ChangeBGColorCMD);
			registerCommand(Command.RENDER_BG_COLOR, RenderBgColorCMD);
			
			registerCommand(Command.CHANGE_BG_IMG, insertBgCommand);
			
			registerCommand(Command.CHANGE_ELEMENT_COLOR, ChangeElementColorCMD);
			registerCommand(Command.CHANGE_ELEMENT_LAYER, ChangeElementLayerCMD);
			registerCommand(Command.CHANGE_ELEMENT_STYLE, ChangeElementStyleCMD);
			registerCommand(Command.CHANGE_ELEMENT_PROPERTY, ChangeElementPropertyCMD);
			
			//复制粘贴
			registerCommand(Command.COPY_ELEMENT, CopyElementCMD);
			registerCommand(Command.PASTE_ELEMENT, PasteElementCMD);
			
			registerCommand(Command.COPY_TEM_GROUP, CopyTemGroupCMD);
			registerCommand(Command.PASTE_TEM_GROUP, PasteTemGroupCMD);
			
			registerCommand(Command.COPY_GROUP, CopyGroupCMD);
			registerCommand(Command.PAST_GROUP, PasteGroupCMD);
			
			registerCommand(Command.CONVERT_PAGE_2_ELEMENT, ConvertPage2ElementCMD);
			registerCommand(Command.CONVERT_ELEMENT_2_PAGE, ConvertElement2PageCMD);
			
			registerCommand(Command.CHANGE_PAGE_INDEX, ChangePageIndexCMD);
		}
		
		/**
		 * 桌面和web插入图片的方式不同，需要不同的command来处理 
		 */		
		public static var inserImgCommad:Class;
		
		public static var insertBgCommand:Class;
		
		public static var delImgCommad:Class;
	}
}

class Key
{
	public function Key()
	{
		
	}
}