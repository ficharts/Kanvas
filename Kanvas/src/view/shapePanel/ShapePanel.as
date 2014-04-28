package view.shapePanel
{
	import com.greensock.TweenLite;
	import com.kvs.ui.Panel;
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.Map;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import control.InteractEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import model.ElementProxy;
	
	import view.ItemSelector;
	import view.shapePanel.pageForCreateCompt.*;
	import view.ui.Canvas;
	
	/**
	 * 图形创建面板，这里是创建各种元素的工厂
	 * 
	 * 不管是简单的图形还是复杂的图形都可以看作是一个
	 * 
	 * 组件
	 * 
	 */	
	public class ShapePanel extends Panel 
	{
		public function ShapePanel(mainApp:Kanvas)
		{
			pagesConfig = XML(ByteArray(new ConfigXML).toString());
			
			shapes;
			image;
			
			circle;
			rect;
			triangle;
			stepTriangle;
			diamond;
			arrow;
			doubleArrow;
			line;
			arrowLine;
			doubleArrowLine;
			
			circleFrame;
			rectFrame;
			triangleFrame;
			stepTriangleFrame;
			diamondFrame;
			arrowFrame;
			doubleArrowFrame;
			star;
			starFrame;
			
			hotspot;
			canvas;
			dashRect;
			dialog;
			
			circle_shape;
			rect_shape;
			
			this.app = mainApp;
			shapeCreateProxy = new ShapeCreateProxy(mainApp);
			
			super();
		}
		
		/**
		 * 主应用
		 */		
		public var app:Kanvas;
		
		/**
		 * 图形创建控制器 
		 */		
		private var shapeCreateProxy:ShapeCreateProxy;
		

		
		
		
		
		//---------------------------------------------------
		//
		//
		// 初始化及导航控制
		//
		//
		//---------------------------------------------------
		
		
		/**
		 */		
		private function exitHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new InteractEvent(InteractEvent.CLOSE_SHAPE_PANE));
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			exitBtn.addEventListener(MouseEvent.CLICK, exitHandler, false, 0, true);
			
			back_up;
			back_over;
			back_down;
			backBtn.iconW = backBtn.iconH = 30;
			backBtn.setIcons("back_up", "back_over", "back_down");
			
			backBtn.w = backBtn.h = 30;
			backBtn.y = 10;
			backBtn.x = 0;
			backBtn.alpha = 0;
			backBtn.mouseEnabled = false;
			addChild(backBtn);
			backBtn.addEventListener(MouseEvent.CLICK, backHandler, false, 0, true); 
			
			// 初始化页面
			pagesContainer.y = this.barHeight
			addChild(pagesContainer);
			
			initPages();
			
			scrollHolder = new ScrollProxy(this);
			scrollHolder.updateMask();
			scrollHolder.update();
			
			render();
		}
		
		/**
		 */		
		private var scrollHolder:ScrollProxy;
		
		/**
		 */		
		override public function updateLayout():void
		{
			super.updateLayout();
			
			if (scrollHolder)
			{
				scrollHolder.updateMask();
				scrollHolder.update();
			}
		}
		
		/**
		 * 图像创建页面的创建和初始化
		 */		
		private function initPages():void
		{
			// 类定义，为根据xml创建对应页面打好基础
			XMLVOLib.resisterClass('home', HomePage);
			XMLVOLib.resisterClass('shapePage', ShapePage);
			XMLVOLib.resisterClass('photo', ItemSelectorPageBase);
			XMLVOLib.resisterClass('smartArt', SmartArtPage);
			XMLVOLib.resisterClass('selector', ItemSelector);
			XMLVOLib.resisterClass('shape', ElementProxy);
			
			var page:ItemSelectorPageBase;
			for each(var pageXML:XML in pagesConfig.page)
			{
				page = XMLVOLib.createRegistedObject(pageXML.@id) as ItemSelectorPageBase;
				XMLVOMapper.fuck(pageXML, page);
				pages.put(page.id, page);
				
				page.w = this.w;
				page.h = 100;
			}
			
			mainPage = currentPage = getPage('home')
			pagesContainer.addChild(mainPage); 
			pagesContainer.addEventListener(ShapePageNavEvt.NAV_TO_TARGET_SHAPE_PAGE, toTargetShapePageHandler, false, 0, true);
			
			
			//直接进入到图形页面
			currentPage = getPage("shapePage");
			pagesContainer.addChild(currentPage);
			reTitle(currentPage.title);
			
			currentPage.x = w;
			pagesContainer.x = - w;
			backBtn.visible = false;
		}
		
		/**
		 * 类型主页面 
		 */		
		private var mainPage:ItemSelectorPageBase;
		
		/**
		 * 跳转到二级页面
		 */		
		private function toTargetShapePageHandler(evt:ShapePageNavEvt):void
		{
			evt.stopPropagation();
			
			// 当组件类型为图片时，直接创建图片
			// 否则跳转到具体的组件创建页
			if (evt.pageID == 'image')
			{
				app.kvsCore.insertIMG();
			}
			else
			{
				currentPage = getPage(evt.pageID);
				currentPage.x = this.w;
				pagesContainer.addChild(currentPage);
				
				reTitle(currentPage.title);
				
				pagesContainer.mouseChildren = pagesContainer.mouseEnabled = false;
				TweenLite.to(pagesContainer, 0.4, {x: - this.w, onComplete: completeNav});
				TweenLite.to(backBtn, 0.3, {alpha: 1, x: 6, delay: 0.2, onComplete:backBtnShowed});
				TweenLite.to(titleUI, 0.5, {x: 20});
				
				scrollHolder.updateMask();
				scrollHolder.update();
			}
		}
		
		/**
		 */		
		private function backBtnShowed():void
		{
			backBtn.mouseEnabled = true;
		}
		
		/**
		 */		
		private function completeNav():void
		{
			pagesContainer.mouseChildren = pagesContainer.mouseEnabled = true;
		}
		
		/**
		 */		
		private function backHandler(evt:MouseEvent):void
		{
			scrollHolder.updateMask();
			
			reTitle(mainPage.title);
			
			pagesContainer.mouseChildren = pagesContainer.mouseEnabled = false;
			
			TweenLite.to(pagesContainer, 0.4, {x: 0, onComplete: removeCurCreatorPage});
			TweenLite.to(backBtn, 0.3, {alpha: 0, x: 0, onComplete:backBtnHide});
			TweenLite.to(titleUI, 0.5, {x: 0});
		}
		
		/**
		 */		
		private function backBtnHide():void
		{
			backBtn.mouseEnabled = false;
		}
		
		/**
		 * 会退交互完成
		 */		
		private function removeCurCreatorPage():void
		{
			pagesContainer.mouseChildren = pagesContainer.mouseEnabled = true;
			
			if (currentPage && pagesContainer.contains(currentPage))
			{
				pagesContainer.removeChild(currentPage);
				currentPage = mainPage;
			}
			
			
			scrollHolder.update();
		}
		
		/**
		 * 根据页面id获取页面
		 */		
		private function getPage(id:String):ItemSelectorPageBase
		{
			return pages.getValue(id) as ItemSelectorPageBase;
		}
		
		/**
		 * 当前的图形创建页面
		 */		
		internal var currentPage:ItemSelectorPageBase;
		
		/**
		 * 所有页面的容器 
		 */		
		internal var pagesContainer:Sprite = new Sprite;
		
		/**
		 * 存放所有创建页面的数据字典
		 */		
		private var pages:Map = new Map;
		
		/**
		 * 页面回退按钮，控制二级页面向主页面的回退
		 */		
		private var backBtn:IconBtn = new IconBtn;
		
		
		
		//------------------------------------------
		//
		//
		//  配置文件
		//
		//
		//------------------------------------------
		
		
		/**
		 * 图形创建面板的配置文件，决定面板中的内容
		 */		
		private var pagesConfig:XML;
		
		[Embed(source="../../shapePanel.xml", mimeType="application/octet-stream")]
		public var ConfigXML:Class;
		
	}
}