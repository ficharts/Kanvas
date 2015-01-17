package view.element
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	
	import model.vo.ElementVO;
	import model.vo.PageVO;
	
	import modules.pages.PageEvent;
	import modules.pages.flash.IFlash;
	
	import util.ElementCreator;
	
	import view.element.state.*;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.ui.ICanvasLayout;
	import view.ui.IMainUIMediator;
	import view.ui.canvas.Canvas;
	import view.ui.canvas.ElementLayoutModel;
	
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
			addChild(_shape = new Shape);
			addChild(pageNumCanvas);
			
			initState();
			doubleClickEnabled = true;
			
			initRenderPoints(4);
			
			StageUtil.initApplication(this, init);
		}
		
		/**
		 * 图片，视频开始动画时需要特殊处理一下
		 */		
		public function startDraw(canvas:Canvas):void
		{
			this.visible = false;
		}
		
		/**
		 * 
		 */		
		public function endDraw():void
		{
			this.visible = canvas.checkVisible(this);
			
			this.renderView();
		}
		
		/**
		 * 渲染元素自身，元素被创建/编辑时，画布缩放动画结束时，
		 */		
		public function renderView():void
		{
			if (canvas && visible)
			{
				var layout:ElementLayoutModel = canvas.getElementLayout(this);
				
				super.x = layout.x;
				super.y = layout.y;
				super.scaleX = layout.scaleX;
				super.scaleY = layout.scaleY;
				super.rotation = layout.rotation;
				
				if (currentState)//临时组合没有状态
					currentState.drawPageNum();
			}
		}
		
		/**
		 * 
		 * 绘制模式下，矢量图形尺寸超过显示区域时需要实体可见，正式渲染，不再绘制
		 * 
		 * 有动画的图形也需要真实可见
		 * 
		 * @return 
		 * 
		 */		
		public function checkTrueRender():Boolean
		{
			return canvas.checkTrueRender(this);
		}
		
		/**
		 * 
		 * 是否是空心图形，空心图形在放大超出舞台后不显示
		 * 
		 */		
		public function get isHollow():Boolean
		{
			return false;
		}
		
		/**
		 * 
		 * 是否含有动画，含有动画效果的元件始终实体可见
		 * 
		 */		
		public function get hasFlash():Boolean
		{
			if (isPage)
			{
				if (pageVO.flashers && pageVO.flashers.length)
					return true;
			}
			
			return false;
		}
		
		/**
		 */		
		private var _ifInViewRect:Boolean = true;

		/**
		 * 是否在可是范围内，绘制模式时，当有的适量元素过大时需要实体可视，从而所有可见元件都得实体可见。
		 */
		public function get ifInViewRect():Boolean
		{
			return _ifInViewRect;
		}

		/**
		 * @private
		 */
		public function set ifInViewRect(value:Boolean):void
		{
			_ifInViewRect = value;
		}

		
		/**
		 * 图形自身的绘制和画布绘制不同，画布绘制时，绘制路径要先转换为画布上的绘制路径
		 * 
		 * 转换之先更新原始绘制点坐标，转换之后用新的绘制点集合绘制图形
		 * 
		 * 有些特殊的图形自身绘制时并不需要绘制点，如文字，图片，视频；
		 * 
		 * 规则的圆，矩形等难以用绘制点方式绘制，两种渲染模式下都不需要更新绘制点信息，直接绘制或者只显示不绘制(画布绘制时)
		 */		
		public function drawView(canvas:Canvas):void
		{
			if (bmd == null) return;
			
			var rect:Rectangle = graphicRect;
			
			renderPoints[0].x = rect.left;
			renderPoints[0].y = rect.top;
			
			renderPoints[1].x = rect.right;
			renderPoints[1].y = rect.top;
			
			renderPoints[2].x =  rect.right;
			renderPoints[2].y =  rect.bottom;
			
			renderPoints[3].x =  rect.left;
			renderPoints[3].y =  rect.bottom;
			
			var layout:ElementLayoutModel = canvas.getElementLayout(this);
			canvas.transformRenderPoints(renderPoints, layout);
			
			var math:Matrix = new Matrix;
			math.rotate(MathUtil.angleToRadian(layout.rotation));
			
			var scale:Number = rect.width * layout.scaleX / bmd.width;
			math.scale(scale, scale);
			
			var p:Point = renderPoints[0];
			
			math.tx = p.x;
			math.ty = p.y;
			
			canvas.graphics.beginBitmapFill(bmd, math, false, false);
			canvas.graphics.moveTo(p.x, p.y);
			
			p = renderPoints[1];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[2];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[3];
			canvas.graphics.lineTo(p.x, p.y);
			
			p = renderPoints[0];
			canvas.graphics.lineTo(p.x, p.y);
			
			canvas.graphics.endFill();
		}
		
		/**
		 * 根据绘制点的数量初始化这些点，他们在绘制图形时会被具体设定好点的数据，这样做是为了防止
		 * 
		 * 绘制时创建大量的点造成的性能消耗，所以点的构造在元素创建时就完成
		 */		
		protected function initRenderPoints(num:uint = 1):void
		{
			renderPoints = new Vector.<Point>;
			while (num)
			{
				renderPoints.push(new Point);
				
				num -= 1;
			}
		}
		
		/**
		 * 存储绘制点集合的数组，通常在元素创建完毕后初始化，会知时仅是刷新具体点的坐标数据，总点数不变
		 */		
		protected var renderPoints:Vector.<Point>;
		
		/**
		 */		
		public function clickedForPreview(cmt:IMainUIMediator):void
		{
			cmt.zoomElement(vo);
		}
		
		/**
		 * 复制出一个新的自己
		 */		
		public function clone():ElementBase
		{
			var element:ElementBase = ElementCreator.getElementUI(vo.clone());
			element.copyFrom = this;
			return element;
		}
		
		/**
		 * 将元件的属性导出为XML数据
		 */		
		public function exportData():XML
		{
			return vo.exportData();
		}
		
		
		
		
		
		
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
		
		/**
		 */		
		override public function get rotation():Number
		{
			return __rotation;
		}
		
		/**
		 */		
		override public function set rotation(value:Number):void
		{
			if (__rotation!= value)
			{
				__rotation = value;
				cos = Math.cos(MathUtil.angleToRadian(rotation));
				sin = Math.sin(MathUtil.angleToRadian(rotation));
				renderView();
			}
		}
		
		/**
		 */		
		private var __rotation:Number;
		
		private var cos:Number = Math.cos(0);
		private var sin:Number = Math.sin(0);
		
		/**
		 */		
		override public function get scaleX():Number
		{
			return __scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			if (__scaleX!= value)
			{
				__scaleX = value;
				renderView();
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
				renderView();
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
				renderView();
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
				renderView();
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
		
		/**
		 */		
		private var __height:Number = 0;
		
		/**
		 */		
		public function toPreview(renderable:Boolean = false):void
		{
			super.visible = previewVisible;
			
			if (renderable)
			{
				alpha = previewAlpha;
				renderView();
			}
		}
		
		/**
		 * 
		 */		
		public function toShotcut(renderable:Boolean = false):void
		{
			previewAlpha   = alpha;
			previewVisible = visible;
			
			if (renderable)
			{
				alpha = 1;
				super.visible = screenshot;
				renderView();
			}
			else
			{
				previewVisible = visible;
				super.visible = false;
			}
		}
		
		/**
		 */		
		protected var previewAlpha  :Number;
		protected var previewVisible:Boolean;
		
		/**
		 */		
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
		
		/**
		 * 
		 */		
		public function get isPage():Boolean
		{
			return Boolean(vo.pageVO);
		}
		
		/**
		 */		
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
				vo.pageVO.addEventListener(PageEvent.DELETE_PAGE_FROM_UI, deletePageHandler);
				vo.pageVO.addEventListener(PageEvent.UPDATE_PAGE_INDEX, updatePageIndex);
				vo.updatePageLayout();
				
				updatePageNum();
				currentState.drawPageNum();
			}
			else
			{
				vo.pageVO.elementVO = null;
				vo.pageVO = null;
				
				clearPageNum();
			}
		}
		
		/**
		 */		
		private function updatePageIndex(e:PageEvent):void
		{
			updatePageNum();
		}
		
		/**
		 * 刷新页面序号的图片数据,这个数据在画布缩放平易时重新绘制
		 */		
		private function updatePageNum():void
		{
			if(isPage)
				pageNumBmd = canvas.getPageNumBmd(pageVO.index)
		}
		
		/**
		 *  保证页面编号控制在和尺寸内
		 * 
		 *  缩放单个元件时，为了让缩放过程中页码同步更新尺寸，需要一个临时比例，因为此时VO上的比例并未生效，
		 * 
		 * 	缩放结束时才生效
		 */		
		public function renderPageNum(temScale:Number = NaN):void
		{
			if (isPage)
			{
				if (isNaN(temScale))
					temScale = vo.scale;
					
				var mat:Matrix = new Matrix;
				var scale:Number = temScale * canvas.scale;
				var showSize:Number = pageNumBmd.width * scale; //实际现实的尺寸
				
				var drawSize:Number;//绘制尺寸
				
				if (showSize > maxNumSize)
					drawSize = maxNumSize / scale;
				else
					drawSize = pageNumBmd.width;
				
				pageNumCanvas.graphics.clear();
				BitmapUtil.drawBitmapDataToShape(pageNumBmd, pageNumCanvas, 
					drawSize, drawSize, 
					- vo.width / 2 - drawSize / 2, - drawSize / 2, 
					true);
			}
			
		}
		
		/**
		 */		
		private function clearPageNum():void
		{
			pageNumCanvas.graphics.clear();
			pageNumBmd = null;
		}
		
		/**
		 */		
		private var maxNumSize:uint = 30;
		
		/**
		 */		
		private var pageNumBmd:BitmapData
		
		/**
		 * 用来绘制页面序号 
		 */		
		public var pageNumCanvas:Shape = new Shape;
		
		/**
		 */		
		private function deletePageHandler(e:PageEvent):void
		{
			if (elementPageConvertable && isPage)
				dispatchEvent(new ElementEvent(ElementEvent.CONVERT_PAGE_2_ELEMENT, this));
			else
				del();
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
		
		/**
		 * 
		 */		
		public function get index():int
		{
			return (parent) ? parent.getChildIndex(this) : -1;
		}
		
		/**
		 * 图形区域，用于辅助在全局画布上绘制
		 */		
		protected function get graphicRect():Rectangle
		{
			return flashShape.getBounds(flashShape);
		}
		
		/**
		 * 应用动画效果的容器，参与动画的图形都被放到这里
		 */		
		public function get flashShape():DisplayObject
		{
			return graphicShape;
		}
		
		/**
		 */		
		override public function get graphics():Graphics
		{
			return _shape.graphics;
		}
		
		/**
		 * 用于基础的图形绘制，碰撞检测
		 */		
		public function get graphicShape():DisplayObject
		{
			return _shape;
		}
		
		/**
		 */		
		protected var _shape:Shape;
		
		/**
		 * 根容器
		 */		
		public function get canvas():Canvas
		{
			return parent as Canvas;
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
		public function getChilds(group:Vector.<IElement>):Vector.<IElement>
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
			
			//选择页面时，对应的页面列表中的页面需被选中
			if (this.isPage)
				vo.pageVO.dispatchEvent(new PageEvent(PageEvent.PAGE_SELECTED, vo.pageVO, false));
		}
		
		/**
		 * 进入没选中状态
		 */
		public function toUnSelectedState():void
		{
			currentState.toUnSelected();
		}
		
		/**
		 * 进入演示模式时，需要先设置好动画到开始位置
		 */		
		public function toPrevState():void
		{
			currentState.toPrevState();
			
			if (isPage)
			{
				this.vo.pageVO.flashIndex = 0;
				var flasher:IFlash;
				
				for each (flasher in vo.pageVO.flashers)
					flasher.start();
			}
		}
		
		/**
		 * 播放元素内部的动画
		 */		
		public function play():void
		{
			
		}
		
		/**
		 * 演示结束后，即便没有播放的动画也要设定到动画播放完毕状态
		 */		
		public function returnFromPrevState():void
		{
			currentState.returnFromPrevState();
			
			if (isPage)
			{
				this.vo.pageVO.flashIndex = 0;
				var flasher:IFlash;
				
				for each (flasher in vo.pageVO.flashers)
					flasher.end();
			}
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
		}
		
		/**
		 * 每个元件都会有一个截图，在画布动画时绘制在画布上，这样可以提升
		 */		
		protected var bmd:BitmapData;
		
		/**
		 * 通常resize相当于重新渲染，但对于特殊的复杂组件，调节宽高时渲染会很消耗性能，需要特殊处理
		 * 
		 * 比如图表
		 */		
		public function resizing():void
		{
			render();
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
			bg.graphics.drawRect(- width * .5, - height * .5, width, height);
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
		public function startDragMove():void
		{
			currentState.startMove();
		}
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void { }
		
		/**
		 */		
		public function stopDragMove():void
		{
			currentState.stopMove();
		}
		
		/**
		 */		
		public function clicked():void
		{
			// 非选择状态下才会触发clicked
			if (isPage && clickMoveControl.clickTarget == pageNumCanvas)
			{
				dispatchEvent(new PageEvent(PageEvent.PAGE_NUM_CLICKED, vo.pageVO, true));
				vo.pageVO.dispatchEvent(new PageEvent(PageEvent.PAGE_SELECTED, vo.pageVO, false));
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
		
		/**
		 */		
		public function get pageVO():PageVO
		{
			return vo.pageVO;
		}
		
		/**
		 */		
		private var _vo:ElementVO;
		
		/**
		 * 如果该对象是复制而来，则该属性指向源对象。 
		 */
		public var copyFrom:ElementBase;
		
		/**
		 * 从预览状态返回时 ，需要切换到之前的状态
		 * 
		 * 由每个状态负责向回切换，把向回切换的方法保存下来即可
		 */		
		public var returnFromPrevFun:Function; 
		
		
		
	}
}