package landray.kp.mediator
{
	import com.kvs.utils.Map;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import landray.kp.components.Selector;
	import landray.kp.core.*;
	import landray.kp.manager.ManagerPage;
	import landray.kp.maps.main.elements.Element;
	import landray.kp.utils.*;
	import landray.kp.view.*;
	
	import model.vo.BgVO;
	import model.vo.ElementVO;
	
	import util.LayoutUtil;
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	
	import view.interact.zoomMove.ZoomMoveControl;
	import view.ui.Canvas;
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;
	
	/**
	 * Viewer的辅助类，事件处理，缩放控制，样式切换等。
	 * 
	 */
	public final class MediatorViewer implements IMainUIMediator
	{
		public function MediatorViewer()
		{
			initialize();
		}
		
		/**
		 */		
		public function setPageIndex(value:int):void
		{
			pageManager.index = value;
		}
		
		/**
		 * 镜头对焦到某元素上
		 */		
		public function zoomElement(elementVO:ElementVO):void
		{
			config.kp_internal::controller.zoomElement(elementVO);
		}
		
		/**
		 */		
		public function zoomAuto():void
		{
			config.kp_internal::controller.zoomAuto();
		}
		
		/**
		 */		
		public function get mainUI():MainUIBase
		{
			return this.viewer;
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			config = KPConfig.instance;
			
			kp_internal::setTemplete(KPProvider.instance.styleXML);
			
			if (stage) 
				addedToStage();
			else 
				viewer.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
		}
		
		private function initializeStage():void
		{
			lastWidth  = stage.stageWidth;
			lastHeight = stage.stageHeight;
			
			stage.addEventListener(Event.RESIZE, resize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreen);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel, false, 0, true);
			stage.focus = viewer;
			
			viewer.width  = lastWidth;
			viewer.height = lastHeight;
			viewer.addEventListener(MouseEvent.CLICK, click);
			viewer.dispatchEvent(new Event("initialize"));
		}
		
		private function resizeStage():void
		{
			if (screenFull)
			{
				screenFull = false;
			}
			else
			{
				var thisWidth :Number = stage.stageWidth;
				var thisHeight:Number = stage.stageHeight;
				canvas.x += (thisWidth  - lastWidth ) * .5;
				canvas.y += (thisHeight - lastHeight) * .5;
				lastWidth  = thisWidth;
				lastHeight = thisHeight;
			}
		}
		
		/**
		 * 画布开始动画
		 */		
		public function flashPlay():void
		{
			for each (var graph:Graph in graphs)
				graph.flashPlay();
		}
		
		/**
		 * 画布动画结束
		 */		
		public function flashStop():void
		{
			for each (var graph:Graph in graphs)
				graph.flashStop();
		}
		
		public function flashTrek():void
		{
			for each (var graph:Graph in graphs)
				graph.flashTrek();
			
			viewer.synBgImageToCanvas();
			
			selector.render();
		}
		
		public function bgClicked():void
		{
			if (selector.visible)
			{
				selector.visible = false;
				ExternalUtil.kanvasUnselected();
			}
		}
		
		/**
		 * @private
		 */
		private function addedToStage(e:Event = null):void
		{
			if (stage.stageWidth && stage.stageHeight)
			{
				viewer.removeEventListener(Event.ADDED_TO_STAGE, addedToStage, false);
				initializeStage();
			}
			else 
			{
				stage.addEventListener(Event.RESIZE, addedToStageResize);
			}
		}
		
		/**
		 * @private
		 */
		private function addedToStageResize(e:Event):void
		{
			if (stage.stageWidth && stage.stageHeight)
			{
				stage.removeEventListener(Event.RESIZE, addedToStageResize);
				initializeStage();
			}
		}
		
		/**
		 * @private
		 */
		private function resize(e:Event):void
		{
			if (stage.stageWidth && stage.stageHeight)
			{
				viewer.width  = stage.stageWidth;
				viewer.height = stage.stageHeight;
				resizeStage();
			}
		}
		
		/**
		 * @private
		 */
		private function keyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 32:
					controller.zoomAuto();
					pageManager.reset();
					break;
				case 37:
				case 38:
					pageManager.prev();
					break;
				case 39:
				case 40:
					pageManager.next();
					break;
			}
		}
		
		/**
		 * @private
		 */
		private function fullScreen(e:FullScreenEvent):void
		{
			if (e.fullScreen == false)
			{

				config.kp_internal::toolBarSlid.kp_internal::resetScreenButtons();
				viewer.screenState = StageDisplayState.NORMAL;
			}
		}
		
		/**
		 * @private
		 */
		private function mouseWheel(e:MouseEvent):void
		{
			if (e.delta > 0)
				controller.zoomIn();
			else if (e.delta < 0)
				controller.zoomOut();
		}
		
		/**
		 * @private
		 */
		private function click(e:MouseEvent):void
		{
			try 
			{
				var element:Element = Element(e.target);
				if (element) 
				{
					if (element.related) 
					{
						var visible:Boolean = (element.vo.type!= "hotspot");
						if (visible) 
						{
							selector.render(element);
						}
						ExternalUtil.kanvasLinkClicked(element.vo.id);
					}
				}
				selector.visible = visible;
			} 
			catch(o:Error) { }
		}
		
		/**
		 * @private
		 */
		private function loaded(e:ImgInsertEvent):void
		{
			viewer.drawBGImg(e.bitmapData);
		}
		
		/**
		 * @private
		 */
		kp_internal function centerAdaptive():void
		{
			canvas.rotation = 0;
			canvas.scaleX = canvas.scaleY = 1;
			var bound:Rectangle = LayoutUtil.getContentRect(canvas);
			var stage:Rectangle = viewer.bound;
			var cenC:Point = new Point((bound.left + bound.right) * .5, (bound.top + bound.bottom) * .5);
			var cenS:Point = new Point((stage.left + stage.right) * .5, (stage.top + stage.bottom) * .5);
			canvas.x = cenS.x - cenC.x;
			canvas.y = cenS.y - cenC.y;
		}
		
		/**
		 * @private
		 */
		kp_internal function setBackground(value:BgVO):void
		{
			loader = new ImgInsertor;
			loader.addEventListener(ImgInsertEvent.IMG_LOADED, loaded, false, 0, true);
			loader.loadImgBytes(CoreUtil.imageLibGetData(value.imgID));
		}
		
		/**
		 * @private
		 */
		kp_internal function setTemplete(value:XML):void
		{
			CoreUtil.registLib(lib);
			
			var templetes:XML = XML(value.child("template").toXMLString());
			for each(var item:XML in templetes.children())
				CoreUtil.registLibXMLWhole(item.@id, item, item.name().toString());
			
			themes.clear();
			
			var themesXML:XML = XML(value.child('themes').toXMLString());
			for each(item in themesXML.children()) 
				themes.put(item.name().toString(), item);
		}
		
		/**
		 * @private
		 */
		kp_internal function setTheme(value:String):void
		{
			if (themes.containsKey(value)) 
			{
				CoreUtil.registLib(lib);
				CoreUtil.clearLibPart();
				
				var theme:XML = themes.getValue(value) as XML;
				for each (var item:XML in theme.children()) 
					CoreUtil.registLibXMLPart(item.@styleID, item, item.name().toString());
				
				viewer.kp_internal::drawBackground(CoreUtil.getColor(background));
			}
		}
		
		kp_internal function setScreenState(value:String):void
		{
			screenFull = (value == "fullScreen");
			if(isNaN(lastWidth) || isNaN(lastHeight))
			{
				lastWidth  = stage.stageWidth;
				lastHeight = stage.stageHeight;
			}
			stage.displayState = value;
			var thisWidth :Number = stage.stageWidth;
			var thisHeight:Number = stage.stageHeight;
			var recOld:Rectangle = new Rectangle(5, 5, lastWidth - 10, lastHeight - 50);
			var recNew:Rectangle = new Rectangle(5, 5, thisWidth - 10, thisHeight - 50);
			if (value == "fullScreen")
			{
				screenScale = (recOld.width / recOld.height > recNew.width / recNew.height)
					? recNew.width  / recOld.width
					: recNew.height / recOld.height;
			}
			else
			{
				screenScale = 1 / screenScale;
			}
			var canvasToScale:Number = canvas.scaleX * screenScale;
			var vector:Point = new Point((thisWidth - lastWidth) * .5, (thisHeight - lastHeight) * .5);
			canvas.x += vector.x;
			canvas.y += vector.y;
			recOld.offset(vector.x, vector.y);
			recOld.width  *= screenScale;
			recOld.height *= screenScale;
			var tl:Point = new Point(recOld.x, recOld.y);
			LayoutUtil.convertPointStage2Canvas(tl, canvas.x, canvas.y, canvas.scaleX, canvas.rotation);
			LayoutUtil.convertPointCanvas2Stage(tl, canvas.x, canvas.y, canvasToScale, canvas.rotation);
			recOld.x = tl.x;
			recOld.y = tl.y;
			var canvasCenter:Point = new Point((recOld.left + recOld.right) * .5, (recOld.top + recOld.bottom) * .5);
			var stageCenter :Point = new Point((recNew.left + recNew.right) * .5, (recNew.top + recNew.bottom) * .5);
			var aimX:Number = canvas.x + stageCenter.x - canvasCenter.x;
			var aimY:Number = canvas.y + stageCenter.y - canvasCenter.y;
			controller.zoomRotateMoveTo(canvasToScale, canvas.rotation, aimX, aimY, null, 1);
			
			viewer.synBgImageToCanvas();
			
			lastWidth  = thisWidth;
			lastHeight = thisHeight;
		}
		
		
		private function get background():BgVO
		{
			return config.kp_internal::bgVO;
		}
		
		private function get viewer():Viewer
		{
			return config.kp_internal::viewer;
		}
		
		private function get canvas():Canvas
		{
			return config.kp_internal::viewer.canvas;
		}
		
		private function get controller():ZoomMoveControl
		{
			return config.kp_internal::controller;
		}
		
		private function get selector():Selector
		{
			return config.kp_internal::selector;
		}
		
		private function get pageManager():ManagerPage
		{
			return config.kp_internal::pageManager;
		}
		
		private function get lib():XMLVOLib
		{
			return config.kp_internal::lib;
		}
		
		private function get themes():Map
		{
			return config.kp_internal::themes;
		}
		
		private function get graphs():Vector.<Graph>
		{
			return config.kp_internal::graphs;
		}
		
		private function get stage():Stage
		{
			return config.kp_internal::viewer.stage;
		}
		
		/**
		 * @private
		 */
		private var config:KPConfig;
		
		/**
		 * @private
		 */
		private var loader:ImgInsertor;
		
		private var lastWidth:Number;
		
		private var lastHeight:Number;
		
		private var screenScale:Number;
		
		private var screenFull:Boolean;
	}
}