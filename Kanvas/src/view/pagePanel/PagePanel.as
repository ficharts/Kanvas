package view.pagePanel
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.kvs.ui.FiUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import commands.Command;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import model.CoreFacade;
	import model.ElementProxy;
	import model.vo.PageVO;
	
	import modules.pages.PageEvent;
	import modules.pages.PageManager;
	
	import view.interact.interactMode.PrevMode;
	
	/**
	 * 负责页面创建命令发出，页面列表显示，页面顺序调换命令发出
	 */	
	public class PagePanel extends FiUI
	{
		public function PagePanel(kvs:Kanvas)
		{
			super();
			
			this.core = kvs;
			this.w = 130;
		}
		
		/**
		 * 核心Core初始化完毕后才可以调用此方法
		 */		
		public function initPageManager():void
		{
			this.pageManager = CoreFacade.coreMediator.pageManager;
			
			pageManager.addEventListener(PageEvent.PAGE_ADDED, pageAdded);
			pageManager.addEventListener(PageEvent.UPDATE_PAGES_LAYOUT, layoutPages);
			pageManager.addEventListener(PageEvent.PAGE_DELETED, pagedDeleted);
			
			this.addEventListener(PageEvent.PAGE_SELECTED, pageSelectedFromCore);
		}
		
		/**
		 */		
		private function pageSelectedFromCore(evt:PageEvent):void
		{
			setCurrentPage(findPageUIByVO(evt.pageVO));
			pageManager.index = evt.pageVO.index;//仅仅选择页面时，只刷新index信息，不zoom
			
			udpateScrollForCurrPage();
		}
		
		/**
		 */		
		private var pageManager:PageManager;
		
		
		
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		//  页面操作，包含添加编辑与删除等
		//
		//
		//
		//------------------------------------------------
		
		
		
		/**
		 * 告知core去创建一个页面
		 */		
		public function addPage():void
		{
			_addPage();
		}
		
		/**
		 * Enter键会触发
		 */		
		private function keyBoardShot(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ENTER)
			{
				_addPage();
			}
		}
		
		/**
		 */		
		private function _addPage():void
		{
			if (currentPage)
				CoreFacade.coreMediator.addPage(currentPage.pageVO.index + 1);
			else
				CoreFacade.coreMediator.addPage(pages.length);
		}
		
		/**
		 * core页面创建成功反馈
		 */		
		public function pageAdded(evt:PageEvent):void
		{
			_pageAdded(evt.pageVO);
		}
		
		/**
		 */		
		private function _pageAdded(pageVO:PageVO):void
		{
			var pageUI:PageUI = new PageUI(pageVO, core.kvsCore);
			
			pageUI.w = scrollProxy.viewWidth;
			pageUI.h = pageHeight;
			
			pageUI.iconW = 90;
			pageUI.iconH = 67.5;
			
			pageUI.styleXML = pageStyleXML;
			
			pagesCtn.addChild(pageUI);
			pages.push(pageUI);
			
			setCurrentPage(pageUI);
		}
		
		/**
		 */		
		private var pageHeight:uint = 80;
		
		/**
		 */		
		private var pages:Vector.<Object> = new Vector.<Object>;
		
		/**
		 * 从core中删除了某个页面后，页面的删除最终都源自core
		 */		
		public function pagedDeleted(evt:PageEvent):void
		{
			if (evt.pageVO)
			{
				var pageUI:PageUI = findPageUIByVO(evt.pageVO);
				
				pages.splice(pages.indexOf(pageUI), 1);
				pagesCtn.removeChild(pageUI);
				
				//trace(pageUI.pageVO.index);
				
				if (pageUI == currentPage)
				{
					currentPage.selected = false;
					currentPage = null;
				}
				
				
				return;
				
				if (pages.length)
				{
					pageUI = getPageByIndex(pageUI.pageVO.index);
					
					setCurrentPage(pageUI);
					
					//scrollProxy.update();
					udpateScrollForCurrPage();
				}
			}
			else
			{
				while (pagesCtn.numChildren) pagesCtn.removeChildAt(0);
				pages.length = 0;
				currentPage = null;
			}
		}
		
		/**
		 * 从页面列表中选择了某个页面
		 */		
		public function pageSelected(pageVO:PageVO):void
		{
			//通知核心core切换至当前page
			pageManager.indexWithZoom = pageVO.index;
		}
		
		/**
		 * 页面初始化，数据导入时用到
		 */		
		public function initPages(pages:Vector.<PageVO>):void
		{
			var pageVO:PageVO;
			for each (pageVO in pages)
			{
				_pageAdded(pageVO);
			}
		}
		
		/**
		 * 根据页面的序号重新排列所有页面，并更新序号显示
		 */		
		private function layoutPages(evt:PageEvent):void
		{
			var pageUI:PageUI;
			for each (pageUI in pages)
			{
				pageUI.y = pageUI.pageVO.index * pageUI.h;
				
				pageUI.updataLabel();
			}
			
			scrollProxy.updateScrollBar();
			
			udpateScrollForCurrPage();
		}
		
		/**
		 * 保证当前页可见
		 */		
		private function udpateScrollForCurrPage():void
		{
			if (currentPage)
			{
				scrollProxy.scrollTo(currentPage.y, currentPage.y + currentPage.height);
			}
		}
		
		/**
		 */		
		private function pageDown(evt:PagePanelEvent):void
		{
			setCurrentPage(evt.pageUI);
			udpateScrollForCurrPage();
		}
		
		
		/**
		 * 按下并释放页面，切换至当前页
		 */		
		private function pageClicked(evt:PagePanelEvent):void
		{
			pageSelected(evt.pageUI.pageVO);
		}
		
		/**
		 * 将当前page切换到指定页
		 */		
		private function setCurrentPage(pageUI:PageUI):void
		{
			if (currentPage)
			{
				currentPage.selected = false;
			}
			
			if (pageUI)
			{
				currentPage = pageUI;
				currentPage.selected = true;
			}
		}
		
		/**
		 */		
		private function findPageUIByVO(pageVO:Object):PageUI
		{
			var pageUI:PageUI;
			for each(pageUI in pages)
			{
				if (pageUI.pageVO == pageVO)
					break;
			}
			
			return pageUI;
		}
		
		/**
		 */		
		private function findPageByIndex(index:int):PageUI
		{
			if (index < 0)
				index = 0;
			else if (index >= pages.length)
				index = pages.length - 1;
				
			var page:PageUI;
			
			for each (page in pages)
			{
				if (page.pageVO.index == index)
					break;
			}
			
			return page;
		}
		
		/**
		 */		
		private var currentPage:PageUI;
		
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		//  拖拽方式创建页面
		//
		//
		//
		//------------------------------------------------
		
		/**
		 */		
		internal function startCreatePageByDrag():void
		{
			var rect:Rectangle = this.addPageBtn.getRect(stage);
			addPageBtn.tips = "添加页面";
			var bmd:BitmapData = BitmapUtil.getBitmapData(this.addPageBtn, true);
			
			pageCreateIcon.graphics.clear();
			BitmapUtil.drawBitmapDataToSprite(bmd, pageCreateIcon, bmd.width, bmd.height, 0, 0, true);
			
			pageCreateIcon.x = rect.x;
			pageCreateIcon.y = rect.y;
			pageCreateIcon.startDrag();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, outShapePanelHandler, false, 0, true);
		}
		
		/**
		 */		
		private function outShapePanelHandler(evt:MouseEvent):void
		{
			if (pageCreateIcon.x > this.w )
			{
				var rect:Rectangle = pageCreateIcon.getRect(stage);
				pageCreateIcon.stopDrag();
				pageCreateIcon.graphics.clear();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, outShapePanelHandler);
				
				rect.x += rect.width / 2;
				rect.y += rect.height / 2;
				
				var page:ElementProxy = new ElementProxy;
				
				page.x = rect.x;
				page.y = rect.y;
				
				page.width = 120;
				page.height = 90;
				page.rotation = - core.kvsCore.canvas.rotation;
				page.index = (currentPage) ? currentPage.pageVO.index + 1 : pages.length;
				
				core.kvsCore.createPage(page);
				
				core.kvsCore.hideSelector();
				core.kvsCore.startDragElement();
			}
		}
		
		/**
		 */		
		private var pageCreateIcon:Sprite = new Sprite;
		
		/**
		 */		
		internal function endCreatePageByDrag():void
		{
			pageCreateIcon.stopDrag();
			pageCreateIcon.graphics.clear();
			
			core.kvsCore.endDragElement();
			
			// 抖动效果
			if (core.kvsCore.currentElement)
			{
				var tgtScale:Number = core.kvsCore.currentElement.scale * 0.8;
				TweenLite.killTweensOf(core.kvsCore.currentElement, true);
				TweenLite.from(core.kvsCore.currentElement, 1, {scaleX: tgtScale, scaleY: tgtScale, ease: Elastic.easeOut});
				core.kvsCore.showSelector();
			}
		}
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		//  页面拖拽控制, 用户调整页面顺序
		//
		//
		//
		//------------------------------------------------
		
		/**
		 */		
		private function startDragPage(evt:PagePanelEvent):void
		{
			evt.stopPropagation();
			
			if (pages.length < 2)
				return;
			
			pagesCtn.mouseChildren = false;
			
			currentDragPageUI = evt.pageUI;
			
			setCurrentPage(currentDragPageUI);
			currentDragPageUI.hoverUI();
			drawCurPageProxy();
			
			temPoint.x = currentDragPageUI.x;
			temPoint.y = currentDragPageUI.y;
			temPoint = pagesCtn.localToGlobal(temPoint);
			
			currentDragPageUI.x = temPoint.x;
			currentDragPageUI.y = temPoint.y;
			stage.addChild(currentDragPageUI);
			
			currentDragPageIndex = currentDragPageUI.pageVO.index;
			
			sendingDraggPageVO = currentDragPageUI.pageVO;
			sendingPageVOIndex = currentDragPageIndex;
			
			evt.pageUI.startDrag();
		}
		
		/**
		 * 正在被拖放的页面 
		 */		
		private var currentDragPageUI:PageUI;
		
		/**
		 * 页面开始拖拽时，当前页面的位置
		 */		
		private var currentDragPageIndex:int;
		
		
		/**
		 */		
		private function pageDragging(evt:PagePanelEvent):void
		{
			evt.stopPropagation();
			
			if (currentDragPageUI)
			{
				var min:Number = curPageStartY;
				var max:Number = currPageEndY;
				
				var pageY:Number = getPagePos(currentDragPageUI).y;
				
				
				// 向上拖动
				if (pageY < min && currentDragPageIndex >= 1)
				{
					pageManager.setPageIndex(getPageByIndex(currentDragPageIndex - 1).pageVO, currentDragPageIndex);
					currentDragPageIndex -= 1;
					
					updateTemPageLayout();
				}
				else if (pageY > max && currentDragPageIndex < pages.length - 1)// 向下拖动
				{
					pageManager.setPageIndex(getPageByIndex(currentDragPageIndex + 1).pageVO, currentDragPageIndex);
					currentDragPageIndex += 1;
					
					updateTemPageLayout();
				}
				else
				{
					
				}
			}
		
		}
		
		private var sendingDraggPageVO:PageVO;
		private var sendingPageVOIndex:int;
		
		/**
		 */		
		private function stopDragPage(evt:PagePanelEvent):void
		{
			evt.stopPropagation();
			
			if (currentDragPageUI)
			{
				pagesCtn.mouseChildren = true;
				
				currentDragPageUI.stopDrag();
				
				pagesCtn.addChild(currentDragPageUI);
				currentDragPageUI = null;
				
				var pageUI:PageUI;
				for each (pageUI in pages)
				{
					pageUI.x = 0;
					pageUI.y = pageUI.pageVO.index * pageUI.h;
					pageUI.updataLabel();
				}
				if (sendingDraggPageVO.index != sendingPageVOIndex)
				{
					var obj:Object = {pageVO:sendingDraggPageVO, oldIndex:sendingPageVOIndex, newIndex:sendingDraggPageVO.index};
					CoreFacade.coreMediator.sendNotification(Command.CHANGE_PAGE_INDEX, obj);
				}
				
				pagesCtn.graphics.clear();
			}
			
		}

		
		/**
		 * 拖拽页面时，临时更新页面的布局
		 */		
		private function updateTemPageLayout():void
		{
			var pageUI:PageUI;
			for each (pageUI in pages)
			{
				if (currentDragPageUI != pageUI)
				{
					pageUI.x = 0;					
					pageUI.y = pageUI.pageVO.index * pageHeight;
				}
			}
			
			drawCurPageProxy();
			
			//更新滚动位置，以便当前页面可以被显示
			scrollProxy.scrollTo(currentDragPageUI.pageVO.index * pageHeight, (currentDragPageUI.pageVO.index + 1) * pageHeight);
		}
		
		/**
		 * 绘制当前拖拽页面的临时预设位置
		 */		
		private function drawCurPageProxy():void
		{
		    pagesCtn.graphics.clear();
			pagesCtn.graphics.beginFill(0x4295dd);
			pagesCtn.graphics.drawRect(20, currentDragPageUI.pageVO.index * pageHeight + 10, 5, pageHeight - 20);
			pagesCtn.graphics.endFill();
		}
		
		/**
		 * 当前页面的Y值
		 */		
		private function get curPageStartY():Number
		{
			return currentDragPageIndex * pageHeight - 40;
		}
		
		/**
		 * 当前页面的Y值加上高度
		 */		
		private function get currPageEndY():Number
		{
			return curPageStartY + pageHeight;
		}
		
		/**
		 * 将页面的全局坐标转换为局部坐标
		 */		
		private function getPagePos(pageUI:PageUI):Point
		{
			temPoint.x = pageUI.x
			temPoint.y = pageUI.y;
			temPoint = pagesCtn.globalToLocal(temPoint);
			
			return temPoint;
		}
		
		/**
		 */		
		private var temPoint:Point = new Point;
		
		/**
		 * 根据位置信息获取页面
		 */		
		private function getPageByIndex(index:int):PageUI
		{
			var pageUI:PageUI;
			
			for each (pageUI in pages)
			{
				if (pageUI.pageVO.index == index)
					break;
			}
			
			return pageUI;
		}
			
		
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		// 
		//
		//
		//
		//------------------------------------------------
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			scrollProxy = new PagesScrollProxy(this);
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
			
			addPageBtn = new ShotBtn(this);
			addPageBtn.buttonMode = false;
			addPageBtn.w = w - gutter * 2 - 4;
			addPageBtn.h = 30;
			addPageBtn.iconW = 50;
			addPageBtn.iconH = 50;
			addPageBtn.tips = "按下或者拖动创建";
			
			shot_up;
			shot_over;
			addPageBtn.styleXML = <states>
										<normal>
											<fill color='#FFFFFF' alpha='1'/>
											<img/>
										</normal>
										<hover>
											<fill color='#dddddd' alpha='1'/>
											<img/>
										</hover>
										<down>
											<fill color='#cccccc' alpha='1'/>
											<img/>
										</down>
									</states>
				
		    addPageBtn.setIcons('shot_up', 'shot_up', 'shot_up');
			this.addChild(addPageBtn);
			
			addChild(pagesCtn);
			
			this.addEventListener(MouseEvent.ROLL_OVER, startKeyBordListen);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyBoardShot);
			
			stage.addEventListener(PagePanelEvent.START_DRAG_PAGE, startDragPage);
			stage.addEventListener(PagePanelEvent.END_DRAG_PAGE, stopDragPage);
			stage.addEventListener(PagePanelEvent.PAGE_DRAGGING, pageDragging);
			
			pagesCtn.addEventListener(PagePanelEvent.PAGE_DOWN, pageDown);
			pagesCtn.addEventListener(PagePanelEvent.PAGE_CLICKED, pageClicked);
			
			updateLayout();
			
			pageCreateIcon.mouseEnabled = false;
			stage.addChild(this.pageCreateIcon)
		}
		
		
		/**
		 */		
		private function startKeyBordListen(evt:MouseEvent):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			stage.addEventListener(MouseEvent.CLICK, stageClick);
			
			ifKeyBord = true;
		}
		
		/**
		 */		
		private var ifKeyBord:Boolean = false;
		
		/**
		 */		
		private function stageClick(evt:MouseEvent):void
		{
			if (ifKeyBord && !this.hitTestPoint(evt.stageX, evt.stageY))
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
				ifKeyBord = false;
			}
		}
		
		/**
		 */		
		private function keyHandler(evt:KeyboardEvent):void
		{
			if (!(CoreFacade.coreMediator.currentMode is PrevMode))
			{
				switch(evt.keyCode)
				{
					case Keyboard.DOWN:
					case Keyboard.RIGHT:
					{
						nextPage();
						break;
					}
					case Keyboard.UP:
					case Keyboard.LEFT:
					{
						prevPage();
						break;
					}
				}
			}
		}
		
		private function nextPage():void
		{
			if (currentPage)
				setCurrentPage(findPageByIndex(currentPage.pageVO.index + 1));
			else
				setCurrentPage(findPageByIndex(0));
			
			pageSelected(currentPage.pageVO);
			udpateScrollForCurrPage();
		}
		
		private function prevPage():void
		{
			if (currentPage)
				setCurrentPage(findPageByIndex(currentPage.pageVO.index - 1));
			else
				setCurrentPage(findPageByIndex(0));
			
			pageSelected(currentPage.pageVO);
			udpateScrollForCurrPage();
		}
		
		/**
		 */		
		public function updateLayout():void
		{
			render();
			
			addPageBtn.x = (w - addPageBtn.w) / 2;
			addPageBtn.y = h - addPageBtn.h - gutter;
			
			scrollProxy.updateMask();
			scrollProxy.update();
		}
		
		/**
		 * 
		 */		
		public function render():void
		{
			graphics.clear();
			bgStyle.width = w;
			bgStyle.height = h;
			StyleManager.drawRect(this, bgStyle);
		}
		
		/**
		 */		
		private var scrollProxy:PagesScrollProxy;
		
		/**
		 * 防止页面的容器 
		 */		
		internal var pagesCtn:Sprite = new Sprite;
		
		/**
		 */		
		internal var gutter:uint = 10;
		
		/**
		 */		
	    internal var addPageBtn:ShotBtn;
		
		/**
		 */		
		private var bgStyle:Style = new Style;
		
		/**
		 */		
		private var core:Kanvas;
		
		/**
		 */		
		public var bgStyleXML:XML;
		
		/**
		 */		
		private var pageStyleXML:XML = <states>
											<normal>
												<fill color='#FFFFFF' alpha='0'/>
												<img/>
											</normal>
											<hover>
												<fill color='#DDDDDD' alpha='0.8'/>
												<img/>
											</hover>
											<down>
												<fill color='#539fd8, #3c92e0' alpha='0.8, 0.8' angle='90'/>
												<img/>
											</down>
										</states>
	}
}