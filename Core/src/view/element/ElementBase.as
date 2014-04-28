package view.element
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.RectangleUtil;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.vo.ElementVO;
	import model.vo.PageVO;
	
	import modules.pages.PageEvent;
	
	import util.ElementCreator;
	import util.ElementUtil;
	import util.LayoutUtil;
	import util.StyleUtil;
	
	import view.element.state.*;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.ui.Canvas;
	import view.ui.ICanvasLayout;
	
	/**
	 * 所有元素UI的基类
	 * 
	 * 元素包括、图片、形状、视频、线条、文字
	 */
	public class ElementBase extends Sprite implements IClickMove, ICanvasLayout, IElement
	{
		public function ElementBase(vo:ElementVO)
		{
			this.vo = vo;
			
			_screenshot = true;
			mouseChildren = false;
			addChild(graphicShape = new Shape);
			
			initState();
			StageUtil.initApplication(this, init);
		}
		
		/**
		 * 将元件的属性导出为XML数据
		 */		
		public function exportData():XML
		{
			return vo.exportData(xmlData);
		}
		
		/**
		 * 数据导出时用到，将VO的各项属性转换为XML数据
		 */		
		public var xmlData:XML;
		
		
		
		
		
		
		
		
		//------------------------------------------------------
		//
		//
		//  图形控制点机制， 控制图形的原始尺寸， 特征点如圆角， 等
		//
		//  每种图形控制点各异，与型变控制器搭档, 实现整个控制 
		//
		//
		//-------------------------------------------------------
		
		
		/**
		 * 
		 * 每种图形需要的控制器不同, 各自负责控制器的开启与关闭, 图形被选择后会调用
		 * 
		 * 此方法
		 * 
		 */		
		public function showControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = true;
			ViewUtil.show(selector.scaleRollControl);
		}
		
		/**
		 * 隐藏型变控制点， 图形被取消选择后会调用此方法
		 */		
		public function hideControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = false;
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 * 图形处于选择状态并按下图形时调用
		 */		
		public function hideFrameOnMdown(selector:ElementSelector):void
		{
			selector.frame.alpha = 0.5;
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 * 图形移动结束后或者临时组合被按下并释放后调用此方法，显示型变框
		 */		
		public function showSelectorFrame(selector:ElementSelector):void
		{
			selector.frame.alpha = 1;
			ViewUtil.show(selector.scaleRollControl);
		}
		
		/**
		 * 元件自己决定开启那个工具条，不同类型元件的工具条各异
		 */		
		public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.defaultShape);
		}
		
		
		
		
		
		
		
		
		
		
		//-------------------------------------------------
		//
		//
		//  鼠标滑过效果
		//
		//
		//--------------------------------------------------
		
		
		
		/**
		 * 效果绘制的范围需要从全局获取
		 */		
		public function renderHoverEffect(style:Style):void
		{
			//记录下此样式是为了在多选/组合式显示子元素的边框
			hoverStyle.border = style.border;
			hoverStyle.fill = style.fill;
			hoverStyle.tx = style.tx;
			hoverStyle.ty = style.ty;
			hoverStyle.width = style.width;
			hoverStyle.height = style.height;
			
			showHoverEffect();
		}
		
		/**
		 * 显示鼠标状态
		 */		
		public function showHoverEffect():void
		{
			hoverEffectShape.graphics.clear();
			StyleManager.setLineStyle(hoverEffectShape.graphics, hoverStyle.getBorder);
			hoverEffectShape.graphics.drawRect(hoverStyle.tx, hoverStyle.ty, hoverStyle.width, hoverStyle.height);
			hoverEffectShape.graphics.endFill();
			
			//hoverEffectShape.graphics.lineStyle(1, 0xFFFFFF, 1, true, 'none');
			//hoverEffectShape.graphics.drawRect(style.tx - 1, style.ty - 1, style.width + 2, style.height + 2);
		}
		
		/**
		 * 隐藏鼠标状态
		 */		
		public function clearHoverEffect():void
		{
			hoverEffectShape.graphics.clear();
		}
		
		/**
		 * 鼠标经过元素
		 */
		protected function mouseOverHandler(evt:MouseEvent):void
		{
			currentState.mouseOver();
		}
		
		/**
		 * 鼠标离开元素
		 */
		protected function mouseOutHandler(evt:MouseEvent):void
		{
			currentState.mouseOut();
		}
		
		/**
		 * 此样式来源于全局鼠标hover样式，而布局信息采集自元件自身
		 */		
		public var hoverStyle:Style = new Style;
		
		
		/**
		 * 鼠标感应效果绘制的画布 
		 */		
		protected var hoverEffectShape:Shape = new Shape;
		
		
		/**
		 * 一个属性，指定拖动该元素时是否影响智能组合拖动
		 */
		public var autoGroupChangable:Boolean = true;
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		//  供外部调用的接口
		//
		//
		//
		//-------------------------------------------------
		
		protected function caculateTransform(point:Point):Point
		{
			var rx:Number = point.x * cos - point.y * sin;
			var ry:Number = point.x * sin + point.y * cos;
			point.x = rx;
			point.y = ry;
			point.x += x;
			point.y += y;
			return point;
		}
		
		public function get topLeft():Point
		{
			tlPoint.x = - .5 * vo.scale * vo.width;
			tlPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(tlPoint);
		}
		
		protected var tlPoint:Point = new Point;
		
		public function get topCenter():Point
		{
			tcPoint.x = 0;
			tcPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(tcPoint);
		}
		protected var tcPoint:Point = new Point;
		
		public function get topRight():Point
		{
			trPoint.x =   .5 * vo.scale * vo.width;
			trPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(trPoint);
		}
		protected var trPoint:Point = new Point;
		
		public function get middleLeft():Point
		{
			mlPoint.x = - .5 * vo.scale * vo.width;
			mlPoint.y = 0;
			return caculateTransform(mlPoint);
		}
		protected var mlPoint:Point = new Point;
		
		public function get middleCenter():Point
		{
			mcPoint.x = x;
			mcPoint.y = y;
			return mcPoint;
		}
		protected var mcPoint:Point = new Point;
		
		public function get middleRight():Point
		{
			mrPoint.x = .5 * vo.scale * vo.width;
			mrPoint.y = 0;
			return caculateTransform(mrPoint);
		}
		protected var mrPoint:Point = new Point;
		
		public function get bottomLeft():Point
		{
			blPoint.x = - .5 * vo.scale * vo.width;
			blPoint.y =   .5 * vo.scale * vo.height;
			return caculateTransform(blPoint);
		}
		protected var blPoint:Point = new Point;
		
		public function get bottomCenter():Point
		{
			bcPoint.x = 0;
			bcPoint.y = .5 * vo.scale * vo.height;
			return caculateTransform(bcPoint);
		}
		protected var bcPoint:Point = new Point;
		
		public function get bottomRight():Point
		{
			brPoint.x = .5 * vo.scale * vo.width;
			brPoint.y = .5 * vo.scale * vo.height;
			return caculateTransform(brPoint);
		}
		protected var brPoint:Point = new Point;
		
		public function get left():Number
		{
			return x - .5 * vo.scale * vo.width;
		}
		
		public function get right():Number
		{
			return x + .5 * vo.scale * vo.width;
		}
		
		public function get top():Number
		{
			return y - .5 * vo.scale * vo.height;
		}
		
		public function get bottom():Number
		{
			return y + .5 * vo.scale * vo.height;
		}
		
		
		override public function get rotation():Number
		{
			return __rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			if (__rotation!= value)
			{
				__rotation = value;
				cos = Math.cos(MathUtil.angleToRadian(rotation));
				sin = Math.sin(MathUtil.angleToRadian(rotation));
				updateView();
			}
		}
		private var __rotation:Number;
		
		private var cos:Number = Math.cos(0);
		private var sin:Number = Math.sin(0);
		
		override public function get scaleX():Number
		{
			return __scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			if (__scaleX!= value)
			{
				__scaleX = value;
				updateView();
			}
		}
		
		private var __scaleX:Number = 1;
		
		override public function get scaleY():Number
		{
			return __scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			if (__scaleY!= value)
			{
				__scaleY = value;
				updateView();
			}
		}
		
		private var __scaleY:Number = 1;
		
		override public function get x():Number
		{
			return __x;
		}
		
		override public function set x(value:Number):void
		{
			if (__x!= value)
			{
				__x = value;
				updateView();
			}
		}
		
		private var __x:Number = 0;
		
		override public function get y():Number
		{
			return __y;
		}
		
		override public function set y(value:Number):void
		{
			if (__y!= value)
			{
				__y = value;
				updateView();
			}
		}
		
		private var __y:Number = 0;
		
		override public function get width():Number
		{
			return __width;
		}
		
		override public function set width(value:Number):void
		{
			__width = value;
		}
		private var __width:Number = 0;
		
		override public function get height():Number
		{
			return __height;
		}
		
		override public function set height(value:Number):void
		{
			__height = value;
		}
		private var __height:Number = 0;
		
		/**
		 */		
		public function updateView(check:Boolean = true):void
		{
			//PerformaceTest.start("ElementBase.updateView()")
			if (check && stage)
			{
				var rect:Rectangle = LayoutUtil.getItemRect(parent as Canvas, this);
				
				if (rect.width < 1 || rect.height < 1)
				{
					super.visible = false;
				}
				else 
				{
					var boud:Rectangle = LayoutUtil.getStageRect(stage);
					super.visible = RectangleUtil.rectOverlapping(rect, boud);
				}
			}
			
			if (parent && visible)
			{
				var prtScale :Number = parent.scaleX;
				var prtRadian:Number = MathUtil.angleToRadian(parent.rotation);
				var prtCos:Number = Math.cos(prtRadian);
				var prtSin:Number = Math.sin(prtRadian);
				
				//scale
				var tmpX:Number = x * prtScale;
				var tmpY:Number = y * prtScale;
				
				//rotate, move
				super.rotation = parent.rotation + rotation;
				super.scaleX = prtScale * scaleX;
				super.scaleY = prtScale * scaleY;
				super.x = tmpX * prtCos - tmpY * prtSin + parent.x;
				super.y = tmpX * prtSin + tmpY * prtCos + parent.y;
			}
			//PerformaceTest.end("ElementBase.updateView()");
		}
		
		/**
		 */		
		public function toPreview(renderable:Boolean = false):void
		{
			super.visible = previewVisible;
			if (isPage &&　numShape) numShape.visible = true;
			if (renderable)
			{
				alpha = previewAlpha;
				updateView(false);
			}
		}
		
		public function toShotcut(renderable:Boolean = false):void
		{
			previewAlpha   = alpha;
			previewVisible = visible;
			if (isPage &&　numShape) numShape.visible = false;
			if (renderable)
			{
				alpha   = 1;
				super.visible = screenshot;
				updateView(false);
			}
			else
			{
				previewVisible = visible;
				super.visible = false;
			}
		}
		
		protected var previewAlpha  :Number;
		protected var previewVisible:Boolean;
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if (visible) updateView();
		}
		
		public function get screenshot():Boolean
		{
			return _screenshot;
		}
		protected var _screenshot:Boolean;
		
		/**
		 * 
		 * 元素的原始尺寸 乘以 缩放比例  = 实际尺寸；
		 * 
		 */		
		public function get scaledWidth():Number
		{
			var w:Number = vo.width * vo.scale;
			
			//有些图形，例如临时组合是没有样式的
			if(vo.style && vo.style.getBorder)
				w = w + vo.thickness * vo.scale;
			
			return 	w;
		}
		
		/**
		 */		
		public function get scaledHeight():Number
		{
			var h:Number = vo.height * vo.scale;
			
			if(vo.style && vo.style.getBorder)
				h = h + vo.thickness * vo.scale;
			
			return h;		
		}
		
		public function get tempScaledWidth():Number
		{
			var w:Number = vo.width * scale;
			if (vo.style && vo.style.getBorder)
				w = w + vo.thickness * scale;
			return w;
		}
		
		public function get tempScaledHeight():Number
		{
			var h:Number = vo.height * scale;
			if(vo.style && vo.style.getBorder)
				h = h + vo.thickness * scale;
			return h;
		}
		
		public function get stageWidth():Number
		{
			return scaledWidth  * ((parent) ? parent.scaleX : 1);
		}
		
		public function get stageHeight():Number
		{
			return scaledHeight * ((parent) ? parent.scaleX : 1);
		}
		
		public function get isPage():Boolean
		{
			return Boolean(vo.pageVO);
		}
		
		public function setPage(pageVO:PageVO):void
		{
			if (vo.pageVO)
			{
				vo.pageVO.removeEventListener(PageEvent.DELETE_PAGE_FROM_UI, deletePageHandler);
				vo.pageVO.removeEventListener(PageEvent.UPDATE_PAGE_INDEX, updatePageIndex);
			}
			if (pageVO)
			{
				vo.pageVO = pageVO;
				vo.pageVO.elementVO = vo;
				vo.pageVO.thumbUpdatable = false;
				vo.pageVO.x        = vo.x;
				vo.pageVO.y        = vo.y;
				vo.pageVO.width    = vo.width;
				vo.pageVO.height   = vo.height;
				vo.pageVO.scale    = vo.scale;
				vo.pageVO.rotation = vo.rotation;
				vo.pageVO.addEventListener(PageEvent.DELETE_PAGE_FROM_UI, deletePageHandler);
				vo.pageVO.addEventListener(PageEvent.UPDATE_PAGE_INDEX, updatePageIndex);
				vo.pageVO.thumbUpdatable = true;
				drawPageNum();
				layoutPageNum();
			}
			else
			{
				vo.pageVO.elementVO = null;
				vo.pageVO = null;
				clearPageNum();
			}
		}
		
		private function updatePageIndex(e:PageEvent):void
		{
			drawPageNum();
		}
		
		private function deletePageHandler(e:PageEvent):void
		{
			if (elementPageConvertable && isPage)
				dispatchEvent(new ElementEvent(ElementEvent.CONVERT_PAGE_2_ELEMENT, this));
			else
				del();
		}
		
		/**
		 *  保证页面编号控制在和尺寸内
		 * 
		 */		
		public function layoutPageNum(s:Number = NaN):void
		{
			//尺寸缩放时需要临时取表象的信息
			if(!numLabel)
				drawPageNum();
			if (isNaN(s))
				s = vo.scale;
			
			numShape.width = numShape.height = height * .5;
			var temSize:Number = numShape.width * s * parent.scaleX;
			
			if (temSize > maxNumSize)
			{
				var size:Number = maxNumSize / s / parent.scaleX;
				
				numShape.width  = size;
				numShape.height = size;
			}
			
			numShape.x = - width * .5 - numShape.width * .5;
			numShape.y = - numShape.height;
		}
		
		/**
		 */		
		private function drawPageNum(size:Number = 20):void
		{
			if(!numLabel)
			{
				addChild(numShape = new Sprite);
				numShape.addChild(numLabel = new LabelUI);
				numLabel.styleXML = <label radius='0' vPadding='0' hPadding='0'>
										<format color='#FFFFFF' font='黑体' size='12'/>
									</label>;
				numShape.mouseChildren = false;
				numShape.buttonMode = true;
				numShape.cacheAsBitmap = true;
			}
			numLabel.text = (vo.pageVO.index + 1).toString();
			numLabel.render();
			numLabel.x = - numLabel.width  * .5;
			numLabel.y = - numLabel.height * .5;
			
			numShape.graphics.clear();
			numShape.graphics.lineStyle(1, 0, 0.8);
			numShape.graphics.beginFill(0x555555, .8);
			numShape.graphics.drawCircle(0, 0, size * .5);
			numShape.graphics.endFill();
		}
		
		private function clearPageNum():void
		{
			if (numLabel)
			{
				removeChild(numShape);
				numShape = null;
				numLabel = null;
			}
		}
		
		/**
		 */		
		private var maxNumSize:uint = 26;
		
		private var numLabel:LabelUI;
		
		/**
		 * 用来绘制页面序号 
		 */		
		private var numShape:Sprite;
		
		/**
		 * 复制出一个新的自己
		 */		
		public function clone():ElementBase
		{
			return null;
		}
		
		/**
		 * 
		 */		
		protected function cloneVO(newVO:ElementVO):ElementVO
		{
			ElementUtil.cloneVO(newVO, vo);
			
			if (vo.pageVO && vo.pageVO != vo)
			{
				newVO.pageVO = new PageVO;
				ElementUtil.cloneVO(newVO.pageVO, vo.pageVO);
			}
			
			return newVO;
		}
		
		/**
		 */		
		public function set scale(value:Number):void
		{
			this.scaleX = this.scaleY = value;
		}
		
		/**
		 */		
		public function get scale():Number
		{
			return this.scaleX;
		}
		
		/**
		 * 移动去
		 */
		public function moveTo(value:Point):void
		{
			vo.x = value.x;
			vo.y = value.y;
			
			updateLayout();
		}
		
		
		public function get index():int
		{
			return (parent) ? parent.getChildIndex(this) : -1;
		}
		
		override public function get graphics():Graphics
		{
			return graphicShape.graphics;
		}
		
		/**
		 */		
		public function get shape():DisplayObject
		{
			return graphicShape;
		}
		
		
		
		//---------------------------------------------
		//
		//
		// 初始化
		//
		//
		//---------------------------------------------
		
		
		/**
		 * 初始化
		 */
		protected function init():void
		{
			preRender();
			
			//在未给元素应用样式之前是无法自动渲染的
			if (vo.style)
				render();
		}
		
		/**
		 * 构建子对象，初始化状态，控制器， 为渲染做好准备
		 */		
		protected function preRender():void
		{
			addChild(bg); 
			
			addChild(hoverEffectShape);
			disableBG();
			
			doubleClickEnabled = true;
			initListen();
			
			clickMoveControl = new ClickMoveControl(this, this);
			
			if (isPage)
				setPage(vo.pageVO);
		}
		
		/**
		 * 初始化监听
		 */
		protected function initListen():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler, false, 0, true);
		}
		
		/**
		 */		
		protected function mouseDownHandler(evt:MouseEvent):void
		{
			currentState.mouseDown();
		}
		
		/**
		 */		
		protected function mouseUpHandler(evt:MouseEvent):void
		{
			currentState.mouseUp();
		}
		
		/**
		 * 具体的删除指令由元件自身决定
		 * 
		 * 因为不同的删除命令有对应的撤销命令
		 */
		public function del():void
		{
			currentState.del();
		}
		
		/**
		 * 复制，粘贴不同元素对应的command也不同
		 */		
		public function copy():void
		{
			this.dispatchEvent(new ElementEvent(ElementEvent.COPY_ELEMENT));
		}
		
		/**
		 */		
		public function paste():void
		{
			this.dispatchEvent(new ElementEvent(ElementEvent.PAST_ELEMENT));
		}
		
		/**
		 */		
		public function enable():void
		{
			currentState.enable();
		}
		
		/**
		 */		
		public function disable():void
		{
			currentState.disable();
		}
		
		/**
		 * 预览模式下元素不可disable
		 */
		public function get enableChangable():Boolean
		{
			return ! (currentState is ElementPrevState);
		}
		
		
		
		
		//------------------------------------------------
		//
		//
		// 状态切换
		//
		//
		//-------------------------------------------------
		
		/**
		 * 多选时， 仅组合自身和独立元件被纳入；
		 * 
		 * 组合的子元件不被纳入;
		 */		
		public function addToTemGroup(group:Vector.<ElementBase>):Vector.<ElementBase>
		{
			return currentState.addToTemGroup(group);
		}
		
		/**
		 * 组合类的智能组合与一般元素不同，仅包含自己的子元素；
		 * 
		 * 智能组合获取时，自身和组合的子元素一并被获取
		 */		
		public function getChilds(group:Vector.<ElementBase>):Vector.<ElementBase>
		{
			group.push(this);
			
			return group;
		}
		
		public function get grouped():Boolean
		{
			return (currentState is ElementGroupState || currentState is ElementMultiSelected);
		}
		
		/**
		 * 智能组合检测时，组合元件和其子元件不可以被组合
		 */		
		public function get canAutoGrouped():Boolean
		{
			return currentState.canAutoGrouped;
		}
		
		/**
		 * 初始化状态
		 */
		protected function initState():void
		{
			selectedState = new ElementSelected(this);
			unSelectedState = new ElementUnSelected(this);
			multiSelectedState = new ElementMultiSelected(this);
			groupState = new ElementGroupState(this);
			prevState = new ElementPrevState(this);
			
			currentState = unSelectedState;
		}
		
		/**
		 * 进入选中状态, 并通知主场景开启对应的工具条
		 */
		public function toSelectedState():void
		{
			currentState.toSelected();
		}
		
		/**
		 * 进入没选中状态
		 */
		public function toUnSelectedState():void
		{
			currentState.toUnSelected();
		}
		
		/**
		 */		
		public function toPrevState():void
		{
			currentState.toPrevState();
			if (isPage)
				numShape.visible = false;
		}
		
		/**
		 */		
		public function returnFromPrevState():void
		{
			currentState.returnFromPrevState();
			if (isPage)
				numShape.visible = true;
		}
		
		/**
		 * 进入多选状态
		 */
		public function toMultiSelectedState():void
		{
			currentState.toMultiSelection();
		}
		
		/**
		 * 进入到组合状态，此元件被纳入组合的子元件
		 */		
		public function toGroupState():void
		{
			currentState.toGroupState();
		}
		
		/**
		 * 当前状态
		 */
		public var currentState:ElementStateBase;
		
		/**
		 * 选中状态
		 */
		public var selectedState:ElementStateBase;
		
		/**
		 * 没选中状态
		 */
		public var unSelectedState:ElementStateBase;
		
		/**
		 * 多选状态
		 */
		public var multiSelectedState:ElementStateBase;
		
		/**
		 * 组合状态
		 */		
		public var groupState:ElementGroupState;
		
		/**
		 * 预览状态
		 */		
		public var prevState:ElementPrevState;
		
		
		
		
		
		
		
		//----------------------------------------
		//
		//
		//  渲染
		//
		//
		//------------------------------------------
		
		/**
		 * 渲染
		 */
		public function render():void
		{
			updateLayout();
			drawBG();
			if (isPage) layoutPageNum();
		}
		
		/**
		 * 根据模型更新布局和比例
		 */
		public function updateLayout():void
		{
			x = vo.x;
			y = vo.y;
			
			width  = vo.width;
			height = vo.height;
			
			scaleX = scaleY = vo.scale;
			rotation = vo.rotation;
		}
		
		/**
		 * 显示背景，仅进入选择状态后才使得背景
		 * 
		 * 可接受交互感应
		 */		
		public function enableBG():void
		{
			bg.visible = true;
			bg.mouseEnabled = true;
		}
		
		/**
		 */		
		public function disableBG():void
		{
			bg.mouseEnabled = false;
			bg.visible = false;
		}
		
		/**
		 * 画背景, 背景随看不到，但是当元素处于
		 * 
		 * 选择状态下，点击背景是可以拖动元素的;
		 * 
		 * 非选择状态下只能通过点击图像区域才可以拖动元件
		 */
		public function drawBG():void
		{
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000, 0);
			bg.graphics.drawRect(- width / 2, - height / 2, width, height);
			bg.graphics.endFill();
		}
		
		/**
		 * 背景 
		 */
		protected var bg:Sprite = new Sprite;
		
		
		
		
		
		
		
		
		
		//-----------------------------------------------------
		//
		//
		//  点击 与移动图形控制
		//
		//
		//------------------------------------------------------
		
		/**
		 */		
		public function startMove():void
		{
			currentState.startMove();
		}
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void { }
		
		/**
		 */		
		public function stopMove():void
		{
			currentState.stopMove();
		}
		
		/**
		 */		
		public function clicked():void
		{
			// 非选择状态下才会触发clicked
			if (isPage)
			{
				if (clickMoveControl.clickTarget == numShape)
				{
					dispatchEvent(new PageEvent(PageEvent.PAGE_NUM_CLICKED, vo.pageVO, true));
					vo.pageVO.dispatchEvent(new PageEvent(PageEvent.PAGE_SELECTED, vo.pageVO, false));
				}
				else
				{
					currentState.clicked();
				}
			}
			else
			{
				currentState.clicked();
			}
		}
		
		/**
		 *  点击拖动控制 
		 */		
		protected var clickMoveControl:ClickMoveControl;
		
		/**
		 * 从预览状态返回时 ，需要切换到之前的状态
		 * 
		 * 由每个状态负责向回切换，把向回切换的方法保存下来即可
		 */		
		public var returnFromPrevFun:Function; 
		
		/**
		 * 元素能否在页面和普通元素之间互相转换。
		 */
		public function get elementPageConvertable():Boolean
		{
			return  _elementPageConvertable;
		}
		protected var _elementPageConvertable:Boolean = true;
		
		/**
		 * 数据
		 */
		public function get vo():ElementVO
		{
			return _vo;
		}
		
		/**
		 * @private
		 */
		public function set vo(value:ElementVO):void
		{
			_vo = value;
		}
		
		private var _vo:ElementVO;
		
		//绘制图形的画布
		protected var graphicShape:Shape;
	}
}