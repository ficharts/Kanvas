package view.elementSelector
{
	import com.greensock.TweenLite;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import util.CoreUtil;
	import util.layout.ElementLayoutInfo;
	import util.layout.LayoutTransformer;
	
	import view.element.ElementBase;
	import view.elementSelector.customPoint.CustomPointControl;
	import view.elementSelector.lineControl.LineControl;
	import view.elementSelector.scaleRollControl.ScaleRollControl;
	import view.elementSelector.sizeControl.SizeControl;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.CoreMediator;
	
	/**
	 * 快捷属性控制器，控制元素比例和旋转和尺寸型变等;
	 * 
	 * 有一个个子控制器组成，控制着不同元件的图形特性;
	 * 
	 * 元件快捷编辑属性面板也是重要组成部分，主要负责元件样式
	 * 
	 * 和常见基本编辑操作
	 */	
	public class ElementSelector extends Sprite
	{
		public function ElementSelector(coreMdt:CoreMediator)
		{
			super();
			
			this.coreMdt = coreMdt;
			
			layoutTransformer = coreMdt.layoutTransformer;
			layoutInfo = new ElementLayoutInfo(layoutTransformer);
			
			XMLVOMapper.fuck(styleXML, style);
			
			frame.visible = false;
			addChild(frame);
			
			scaleRollControl = new ScaleRollControl(this);
			addControl(scaleRollControl);
			
			sizeControl = new SizeControl(this);
			addControl(sizeControl);
			
			//线条的控制点
			lineControl = new LineControl(this);
			addControl(lineControl);
			
			customPointControl = new CustomPointControl(this);
			addControl(customPointControl);
			
			toolBar = new ToolBarController(this);
			addChild(toolBar);
			
			hide();
		}
		
		/**
		 */		
		public function addControl(ct:IPointControl):void
		{
			ViewUtil.hide(ct as Sprite);
			addChild(ct as DisplayObject);
			controls.push(ct);
		}
		
		/**
		 */		
		public function removeControl(ct:IPointControl):void
		{
			var index:int = controls.indexOf(ct);
			
			if (index != - 1)
				controls.splice(index, 1);
		}
		
		/**
		 */		
		private var controls:Vector.<IPointControl> = new Vector.<IPointControl>;
		
		/**
		 */		
		public var coreMdt:CoreMediator;
		
		/**
		 * 鼠标按下图形时，隐藏部分选择框
		 */		
		public function hideFrameOnMdown():void
		{
			element.hideFrameOnMdown(this);
		}
		
		/**
		 */		
		public function showFrameOnMup():void
		{
			element.showSelectorFrame(this);
		}
		
		/**
		 */		
		public var toolBar:ToolBarController;
		
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		// 
		//  形变控制计算相关公共算法
		//
		//
		//-----------------------------------------------
		
		/**
		 */		
		public var curScale:Number = 1;
		
		/**
		 */		
		public var rDis:Number = 0;
		
		/**
		 * 鼠标到图形中心点的距离
		 */		
		public function get curRDis():Number
		{
			return Math.sqrt(getMpToX(x) * getMpToX(x) + getMpToY(y) * getMpToY(y));
		}
		
		/**
		 * 光标到图形中心点距离
		 */		
		public function getMpToX(x:Number):Number
		{
			return (stage.mouseX - x);
		}
		
		/**
		 * 
		 */		
		public function getMpToY(y:Number):Number
		{
			return (stage.mouseY - y);
		}
		
		/**
		 * 获取当前鼠标位置点相对于元素中心点所构成的角度
		 * 
		 * 范围为0到360;
		 */		
		public function get currentRote():Number
		{
			return getRote(stage.mouseY, stage.mouseX, y, x);
		}
		
		/**
		 * 根据起始点坐标计算出向量角度，范围为0~360;
		 * 
		 * 线条的实际角度
		 * 
		 */		
		public function getRote(endY:Number, endX:Number, startY:Number, startX:Number):Number
		{
			var rote:Number = MathUtil.modRotation(Math.atan2(endY - startY, endX - startX) * 180 / Math.PI);
			var kanvasRote:Number = coreMdt.canvas.rotation;
			
			return MathUtil.modRotation(rote - kanvasRote);
		}
		
		/**
		 * 相对于整个舞台的元素宽度
		 */		
		public function get elementWidthForStage():Number
		{
			return element.vo.width * element.scale * layoutTransformer.canvasScale;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		//---------------------------------------------------
		//
		//
		//  绘制与布局
		//
		//
		//--------------------------------------------------
		
		
		/**
		 * 显示型变框，根据元素刷新型变框布局
		 */		
		public function show(element:ElementBase):void
		{
			layoutInfo.currentElementUI = this.element = element;
			layoutInfo.update();
			
			this.x = layoutInfo.x;
			this.y = layoutInfo.y;
			
			element.showControlPoints(this);
			element.showToolBar(toolBar);
			
			render();
			
			this.visible = true;
			TweenLite.to(this, 0.5, {alpha: 1, onComplete: finishShow});
		}
		
		/**
		 */		
		public function update():void
		{
			if (element)
			{
				layoutInfo.update();
				this.x = Math.ceil(layoutInfo.x);
				this.y = Math.ceil(layoutInfo.y);
				
				render();
			}
		}
		
		/**
		 */		
		public function render():void
		{
			style.tx = layoutInfo.tx - offSet;
			style.ty = layoutInfo.ty - offSet;
			style.width  = layoutInfo.width  + offSet * 2;
			style.height = layoutInfo.height + offSet * 2;
			style.scale  = layoutInfo.scale;
			
			//CoreUtil.drawCircle(0xFF0000, new Point(style.tx, style.ty), 3);
			
			if (frame.visible)
			{
				frame.graphics.clear();
				StyleManager.drawRectOnShape(frame, style);
			}
			
			// 刷新控制器的布局
			var control:IPointControl;
			for each (control in controls)
				control.layout(style);
			
			rote();
		}
		
		/**
		 */		
		public function rote():void
		{
			this.rotation = element.rotation + coreMdt.canvas.rotation;
			toolBar.rotation = - this.rotation;
			
			toolBar.layout(style);
			
			coreMdt.currentMode.drawShotFrame();
		}
		
		/**
		 * 隐藏型变框
		 */		
		public function hide():void
		{
			alpha = 0;
			
			if (element)
				element.hideControlPoints(this);
			
			toolBar.clear();
			ViewUtil.hide(this);
		}
		
		/**
		 */		
		private function finishShow():void
		{
			this.mouseChildren = this.mouseEnabled = true;
		}
		
		
		
		
		
		//------------------------------------------------
		//
		//
		// 控制器
		//
		//
		//-------------------------------------------------
		
		/**
		 * 图形缩放旋转控制
		 */		
		public var scaleRollControl:ScaleRollControl;
		
		/**
		 * 图形尺寸拉伸控制 
		 */		
		public var sizeControl:SizeControl;
		
		/**
		 * 线条控制点 
		 */		
		public var lineControl:LineControl;
		
		/**
		 * 自定义控制点
		 */		
		public var customPointControl:CustomPointControl;
		
		/**
		 * 选择框
		 */		
		public var frame:Shape = new Shape;
		
		/**
		 */		
		public var offSet:uint = 12;
		
		/**
		 */		
		private var style:Style = new Style;
		
		/**
		 */		
		private var styleXML:XML = <style>
										<border color='#DDDDDD' alpha='1' thikness='1'/>
									</style>
		
		/**
		 */		
		public var layoutInfo:ElementLayoutInfo;
		
		/**
		 */
		public var layoutTransformer:LayoutTransformer;
		
		/**
		 */		
		private var _element:ElementBase;
		
		/**
		 */
		public function get element():ElementBase
		{
			return _element;
		}
		
		/**
		 * @private
		 */
		public function set element(value:ElementBase):void
		{
			_element = value;
		}
		
	}
}